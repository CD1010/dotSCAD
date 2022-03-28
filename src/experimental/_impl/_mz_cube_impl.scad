use <_mz_cube_comm.scad>;
use <../../util/shuffle.scad>;

function update(cells, cell) = 
    let(
        x = cell.x,
        y = cell.y,
        z = cell.z,
        rowY = [for(c = cells[z][y]) if(c.x == x) cell else c],
        layerZ = [
            for(r = [0:len(cells[z]) - 1])
            if(r == y) rowY
            else cells[z][r]
        ]
    )
    [
        for(layer = [0:len(cells) - 1])
        if(layer == z) layerZ
        else cells[layer]
    ];

// is (x, y) visited?
function visited(x, y, z, cells) = cells[z][y][x][4];

// is (x, y) visitable?
function visitable(x, y, z, cells, layers, rows, columns) = 
    z >= 0 && z < layers &&    // z bound
    y >= 0 && y < rows &&      // y bound
    x >= 0 && x < columns &&   // x bound
    !visited(x, y, z, cells);  // unvisited

// setting (x, y) as being visited
function set_visited(x, y, z, cells) = update(cells, [x, y, z, get_type(cells[z][y][x]), true]);

// 0(right), 1(top), 2(left), 3(bottom), 4(up), 5(down)
function rand_dirs(c, seed) =
    let(dirs = [0, 1, 2, 3, 4, 5])
    is_undef(seed) ? shuffle(dirs) : shuffle(dirs, c + seed);

// get x value by dir
_next_x_table = [1, 0, -1, 0, 0, 0];
function next_x(x, dir, columns, wrapping) = 
    let(nx = x + _next_x_table[dir])
    wrapping ? (nx + columns) % columns : nx;
    
// get y value by dir
_next_y_table = [0, 1, 0, -1, 0, 0];
function next_y(y, dir, rows, wrapping) = 
    let(ny = y + _next_y_table[dir])
    wrapping ? (ny + rows) % rows : ny;

// get z value by dir
_next_z_table = [0, 0, 0, 0, 1, -1];
function next_z(z, dir, layers, wrapping) = 
    let(nz = z + _next_z_table[dir])
    wrapping ? (nz + layers) % layers : nz;
    
// go right and carve the right wall
function carve_right(x, y, z, cells) = 
    let(cell = cells[z][y][x])
    update(
        cells, 
        z_y_x_wall(cell) ? [x, y, z, 5, true] :
        z_x_wall(cell)   ? [x, y, z, 4, true] : 
        y_x_wall(cell)   ? [x, y, z, 1, true] : [x, y, z, 0, true]
    );

// go top and carve the top wall
function carve_top(x, y, z, cells) = 
    let(cell = cells[z][y][x])
    update(
        cells, 
        z_y_x_wall(cell) ? [x, y, z, 6, true] :
        z_y_wall(cell)   ? [x, y, z, 4, true] :
        y_x_wall(cell)   ? [x, y, z, 2, true] : [x, y, z, 0, true]
    );

// go up and carve the up wall
function carve_up(x, y, z, cells) = 
    let(cell = cells[z][y][x])
    update(
        cells, 
        z_y_x_wall(cell) ? [x, y, z, 3, true] :
        z_y_wall(cell)   ? [x, y, z, 1, true] :
        z_x_wall(cell)   ? [x, y, z, 6, true] : [x, y, z, 0, true]
    );

// go left and carve the right wall of the left cell
function carve_left(x, y, z, cells, columns) = 
    let(
        x_minus_one = x - 1,
        nx = x_minus_one < 0 ? x_minus_one + columns : x_minus_one
    )
    update(
        cells, 
        [nx, y, z, 5, false]
    );

// go bottom and carve the top wall of the bottom cell
function carve_bottom(x, y, z, cells, rows) = 
    let(
        y_minus_one = y - 1,
        ny = y_minus_one < 0 ? y_minus_one + rows : y_minus_one
    )
    update(
        cells, 
        [x, ny, z, 6, false]
    );

// go down and carve the up wall of the down cell
function carve_down(x, y, z, cells, layers) = 
    let(
        z_minus_one = z - 1,
        nz = z_minus_one < 0 ? z_minus_one + layers : z_minus_one
    )
    update(
        cells, 
        [x, y, nz, 3, false]
    );

// 0(right), 1(top), 2(left), 3(bottom), 4(up), 5(down)
function carve(dir, x, y, z, cells, layers, rows, columns) =
    dir == 0 ? carve_right(x, y, z, cells) : 
    dir == 1 ? carve_top(x, y, z, cells) : 
    dir == 2 ? carve_left(x, y, z, cells, columns) : 
    dir == 3 ? carve_bottom(x, y, z, cells, rows) : 
    dir == 4 ? carve_up(x, y, z, cells) : 
    /*dir 5*/  carve_down(x, y, z, cells, layers);

// find out visitable dirs from (x, y)
function visitable_dirs(r_dirs, x, y, z, cells, layers, rows, columns, x_wrapping, y_wrapping, z_wrapping) = [
    for(dir = r_dirs) 
    if(
        visitable(
            next_x(x, dir, columns, x_wrapping), 
            next_y(y, dir, rows, y_wrapping), 
            next_z(z, dir, layers, z_wrapping), 
            cells, layers, rows, columns
        )
    ) 
    dir
];  
    
// go maze from (x, y, z)
function go_maze(x, y, z, cells, layers, rows, columns, x_wrapping = false, y_wrapping = false, z_wrapping = false, seed) = 
    let(
        r_dirs = rand_dirs(x + y * columns + z * rows * columns, seed),
        v_dirs = visitable_dirs(r_dirs, x, y, z, cells, layers, rows, columns, x_wrapping, y_wrapping, z_wrapping),
        nx_cells0 = set_visited(x, y, z, cells),
        leng_v_dirs = len(v_dirs)
    )
    //  have visitable dirs?
    leng_v_dirs == 0 ? nx_cells0 :      // road closed
    // try four directions
    let(nxcells1 = next_cells(x, y, z, v_dirs[0], nx_cells0, layers, rows, columns, x_wrapping, y_wrapping, z_wrapping, seed))
    leng_v_dirs == 1 ? nxcells1 :
    let(nxcells2 = next_cells(x, y, z, v_dirs[1], nxcells1, layers, rows, columns, x_wrapping, y_wrapping, z_wrapping, seed))
    leng_v_dirs == 2 ? nxcells2 : 
    let(nxcells3 = next_cells(x, y, z, v_dirs[2], nxcells2, layers, rows, columns, x_wrapping, y_wrapping, z_wrapping, seed))
    leng_v_dirs == 3 ? nxcells3 : 
    let(nxcells4 = next_cells(x, y, z, v_dirs[3], nxcells3, layers, rows, columns, x_wrapping, y_wrapping, z_wrapping, seed))
    leng_v_dirs == 4 ? nxcells4 : 
    let(nxcells5 = next_cells(x, y, z, v_dirs[4], nxcells4, layers, rows, columns, x_wrapping, y_wrapping, z_wrapping, seed))
    leng_v_dirs == 5 ? nxcells5 : next_cells(x, y, v_dirs[5], nxcells5, layers, rows, columns, x_wrapping, y_wrapping, z_wrapping, seed);

function next_cells(x, y, z, dir, cells, layers, rows, columns, x_wrapping, y_wrapping, z_wrapping, seed) =
    let(
        nx = next_x(x, dir, columns, x_wrapping),
        ny = next_y(y, dir, rows, y_wrapping),
        nz = next_z(z, dir, layers, z_wrapping)
    )
    !visitable(nx, ny, nz, cells, layers, rows, columns) ? // is the dir visitable?
            cells :   // road closed so return cells directly
            go_maze(  // try the cell 
                nx, ny, nz, 
                carve(dir, x, y, z, cells, layers, rows, columns),
                layers, rows, columns,
                x_wrapping, y_wrapping, z_wrapping,
                seed
            );