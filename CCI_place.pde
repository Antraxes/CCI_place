PVector sun_pos = new PVector(0,0);
PVector earth_pos = new PVector(0,-300);
float sun_size = 150;
float earth_size = 50;
float earth_angle;
float radius;
int cell_size = 4;
int rows;
int cols;
int[][] grid;
int[][] new_grid;

void setup() {
    size(1000, 1000);
    
    //changing the rect mode to draw from center! -kamryn
    rectMode(CENTER);
    
    // Conway's Game of Life
    //to find the angle between two points in a polar grid, theta = atan2(point1, point2)
    // where y is verticle distance from origin and x is horizontal distance from origin
    float deltaX = sun_pos.x - earth_pos.x;
    float deltaY = sun_pos.y - earth_pos.y;
    earth_angle = atan2(deltaX, deltaY);

    radius = dist(sun_pos.x, sun_pos.y, earth_pos.x, earth_pos.y);
    
    noStroke();
    frameRate(60);
    rows = height / cell_size;
    cols = width / cell_size;

    grid = new int[cols][rows];
    new_grid = new int[cols][rows];

    for(int x = 0; x < cols; x++) {
        for(int y = 0; y < rows; y++)
        grid[x][y] = int(random(2));
    }
    fill(107, 230, 103); // COLOUR IS HERE
    for(int x = 0; x < cols; x++) {
        for(int y = 0; y < rows; y++)
        if (grid[x][y] == 1) {
            rect(x * cell_size, y* cell_size, cell_size, cell_size);
        }
    }
    // FLuid Sim
    lastTime = millis();
    background(0);
    fill(255);
    gravity = new PVector(0, 9.8 * 100); // assuming 100 pixels in 1 metre
    
    for (int i = 0; i < positions.length; i++) {
        positions[i] = new PVector (random(0, width - particle_radius), random(0, height - particle_radius));
        velocities[i] = new PVector(0,0);
        densities[i] = 1;

    }

    
}
void draw() {


    background(0);
    
    // Rotating Sun
    pushMatrix();
    
    translate(500, 500);

    fill(247, 175, 5);
    ellipse(sun_pos.x, sun_pos.y, sun_size, sun_size);

    earth_pos = new PVector(sun_pos.x + cos(earth_angle) * radius, sun_pos.y + sin(earth_angle) * radius);

    fill(0, 85, 255);
    ellipse(earth_pos.x, earth_pos.y, earth_size, earth_size);

    earth_angle += PI / 180;
    
    popMatrix();
    
    // Rotating Sun
    
    //adding a square inside the circle -kamryn
        fill(179, 34, 176);
        rect(width/2, height/2, 100, 100);
    
    
    // Conway's Game of Life
    fill(107, 230, 103);
    for(int x = 0; x < cols; x++) {
        for(int y = 0; y < rows; y++) {
            if (x == 0 || x == cols - 1 || y == 0 || y == rows - 1) {
                new_grid[x][y] = 0;
            }
            else {
                if (grid[x][y] == 1) {
                    if (numOfNeighbours(x, y) < 2) {
                        new_grid[x][y] = 0;
                    }
                    else if (numOfNeighbours(x, y) == 2 || numOfNeighbours(x, y) == 3) {
                        new_grid[x][y] = 1;
                    }
                    else if (numOfNeighbours(x, y) > 3) {
                        new_grid[x][y] = 0;
                    }
                }
                else {
                    if (numOfNeighbours(x, y) == 3) {
                        new_grid[x][y] = 1;
                    }
                }
            }
        }
    }

    for(int x = 0; x < cols; x++) {
        for(int y = 0; y < rows; y++) {
            if (new_grid[x][y] == 1) {
                rect(x * cell_size, y * cell_size, cell_size, cell_size);
            }
        }
    }
    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
          grid[x][y] = new_grid[x][y];
      }
  }
    float currentTime = millis();
    deltaTime = (currentTime - lastTime) / 1000.0;
    lastTime = currentTime;


    for (int i = 0; i < positions.length; i++){
        densities[i] = calculateDensity(positions[i]);

        PVector pressure_force = calculatePressureForce(i);
        //println(pressure_force);
        if (densities[i] != 0){
            pressure_acceleration = PVector.div(pressure_force, densities[i]);
        }
        else {
            pressure_acceleration = PVector.div(pressure_force, 0.001);
        }
        
        pressure_acceleration.mult(deltaTime);
        velocities[i].add(pressure_acceleration);
        //velocities[i] = pressure_acceleration;

        //velocities[i].add(PVector.mult(gravity, deltaTime));

        positions[i].add(PVector.mult(velocities[i], deltaTime));

        checkBounds(positions[i], velocities[i]);

        fill(69, 199, 255);
        ellipse(positions[i].x, positions[i].y, particle_size, particle_size);
        
      
    }
}
int numOfNeighbours(int x, int y) {
    int neighbours = 0;
    // check if a cells neighbours have a state of 1
    if (grid[x][y-1] == 1) neighbours++;
    if (grid[x][y+1] == 1) neighbours++;
    if (grid[x-1][y-1] == 1) neighbours++;
    if (grid[x-1][y] == 1) neighbours++;
    if (grid[x-1][y+1] == 1) neighbours++;
    if (grid[x+1][y] == 1) neighbours++;
    if (grid[x+1][y-1] == 1) neighbours++;
    if (grid[x+1][y+1] == 1) neighbours++;
    return neighbours;
}
// Conway's Game of Life
