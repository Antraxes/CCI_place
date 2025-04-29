PVector gravity;
int num_of_particles = 1000;
float particle_size = 5;
float particle_radius = particle_size / 2;
PVector[] positions = new PVector[num_of_particles];
PVector[] velocities = new PVector[num_of_particles];
float[] densities = new float[num_of_particles];
float target_density = 5;
float pressure_multiplier = 50;
float lastTime;
float deltaTime;
float collision_damp = 0.8;
float smoothing_radius = 120;
float mass = 10;
PVector pressure_acceleration = new PVector (0,0);

void checkBounds(PVector position, PVector velocity) {
        if (particle_radius > position.x) {
            position.x = particle_radius;
            velocity.x *= -1 * collision_damp;
        }
        else if (width - particle_radius < position.x) {
            position.x = width - particle_radius;
            velocity.x *= -1 * collision_damp;
        }

        if (particle_radius > position.y) {
            position.y = particle_radius;
            velocity.y *= -1 * collision_damp;
        }
        else if (height - particle_radius < position.y) {
            position.y = height - particle_radius;
            velocity.y *= -1 * collision_damp;
        }
}

float smoothingKernel(float radius, float distance) {
    if (distance >= radius) return 0;
    float volume = (PI * pow(radius, 4)) / 6;
    return (radius - distance) * (radius - distance) / volume;
}

float smoothingKernelDerivative(float radius, float distance) {
    if (distance >= radius) return 0;

    float scale = 12 / (PI * pow(radius, 4));
    return (distance - radius) * scale;
    
}

float calculateDensity(PVector current_position) {
    float density = 0;


    for (PVector position : positions) {
        PVector difference = PVector.sub(position, current_position);
        float distance = difference.mag();

        float influence = smoothingKernel(smoothing_radius, distance);
        density += mass * influence;
    }
    return density;
}

float convertDensityToPressure(float density) {
    float density_error = density - target_density;
    float pressure = density_error * pressure_multiplier;
    return pressure;
}

// a property gradient could be a gradient of anything, pressure, viscosity etc...
PVector calculatePressureForce(int particle_index) {
    PVector pressure_force = new PVector(0,0);


    for (int other_particle_index = 0; other_particle_index < num_of_particles; other_particle_index++) {
        if (other_particle_index != particle_index)
        {
            PVector difference = PVector.sub(positions[other_particle_index], positions[particle_index]);
            float distance = difference.mag();

            PVector direction = PVector.sub(positions[other_particle_index], positions[particle_index]);
            if (distance == 0) {
                distance = 0.0001;
            }
            direction.div(distance);

            float slope = smoothingKernelDerivative(smoothing_radius, distance);
            float density = densities[other_particle_index];
            if (density == 0) {
                density = 0.001;
            }
            // -float * PVector * float * float / float

            float shared_pressure = calculateSharedPressure(density, densities[particle_index]);

            direction.mult(shared_pressure);
            direction.mult(slope);
            direction.mult(mass);
            direction.div(density);
            pressure_force.add(direction);
        }

    }

    return pressure_force;
}

float calculateSharedPressure(float densityA, float densityB) {
    float pressureA = convertDensityToPressure(densityA);
    float pressureB = convertDensityToPressure(densityB);
    return (pressureA + pressureB) / 2;
}
