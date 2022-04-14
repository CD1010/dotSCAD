use <voronoi/vrn2_cells_space.scad>;
use <unittest.scad>;

module test_vrn2_cells_space() {
    echo("==== test_vrn2_cells_space ====");

    size = [8, 8];
    grid_w = 4;

    expected =  [[[-0.996543, -1.70766], [[1.2602, -3.27268], [1.12005, -0.461923], [-1.15801, 0.990326], [-2.72186, 0.10962], [-2.91411, -3.13099], [-0.861676, -4.43099]]], [[3.35006, -1.49093], [[5.27814, 0.10962], [3.2378, 0.75377], [1.12005, -0.461923], [1.2602, -3.27268], [2.67904, -3.89773], [5.08589, -3.13099]]], [[7.00346, -1.70766], [[9.2602, -3.27268], [9.12005, -0.461923], [6.84199, 0.990326], [5.27814, 0.10962], [5.08589, -3.13099], [7.13832, -4.43099]]], [[11.3501, -1.49093], [[13.2781, 0.10962], [11.2378, 0.75377], [9.12005, -0.461923], [9.2602, -3.27268], [10.679, -3.89773], [13.0859, -3.13099]]], [[-3.38142, 2.52711], [[-4.7622, 0.75377], [-2.72186, 0.10962], [-1.15801, 0.990326], [-0.861676, 3.56901], [-2.91411, 4.86901], [-5.32096, 4.10227]]], [[1.35604, 1.98269], [[1.12005, -0.461923], [3.2378, 0.75377], [2.67904, 4.10227], [1.2602, 4.72732], [-0.861676, 3.56901], [-1.15801, 0.990326]]], [[4.61858, 2.52711], [[3.2378, 0.75377], [5.27814, 0.10962], [6.84199, 0.990326], [7.13832, 3.56901], [5.08589, 4.86901], [2.67904, 4.10227]]], [[9.35604, 1.98269], [[9.12005, -0.461923], [11.2378, 0.75377], [10.679, 4.10227], [9.2602, 4.72732], [7.13832, 3.56901], [6.84199, 0.990326]]], [[-0.996543, 6.29234], [[1.2602, 4.72732], [1.12005, 7.53808], [-1.15801, 8.99033], [-2.72186, 8.10962], [-2.91411, 4.86901], [-0.861676, 3.56901]]], [[3.35006, 6.50907], [[5.27814, 8.10962], [3.2378, 8.75377], [1.12005, 7.53808], [1.2602, 4.72732], [2.67904, 4.10227], [5.08589, 4.86901]]], [[7.00346, 6.29234], [[9.2602, 4.72732], [9.12005, 7.53808], [6.84199, 8.99033], [5.27814, 8.10962], [5.08589, 4.86901], [7.13832, 3.56901]]], [[11.3501, 6.50907], [[13.2781, 8.10962], [11.2378, 8.75377], [9.12005, 7.53808], [9.2602, 4.72732], [10.679, 4.10227], [13.0859, 4.86901]]], [[-3.38142, 10.5271], [[-4.7622, 8.75377], [-2.72186, 8.10962], [-1.15801, 8.99033], [-0.861676, 11.569], [-2.91411, 12.869], [-5.32096, 12.1023]]], [[1.35604, 9.98269], [[1.12005, 7.53808], [3.2378, 8.75377], [2.67904, 12.1023], [1.2602, 12.7273], [-0.861676, 11.569], [-1.15801, 8.99033]]], [[4.61858, 10.5271], [[3.2378, 8.75377], [5.27814, 8.10962], [6.84199, 8.99033], [7.13832, 11.569], [5.08589, 12.869], [2.67904, 12.1023]]], [[9.35604, 9.98269], [[9.12005, 7.53808], [11.2378, 8.75377], [10.679, 12.1023], [9.2602, 12.7273], [7.13832, 11.569], [6.84199, 8.99033]]]];
    actual =  vrn2_cells_space(size, grid_w, seed = 10);

    for(i = [0:len(actual) - 1]) {
        assertEqualPoint(expected[i][0], actual[i][0]);
        assertEqualPoints(expected[i][1], actual[i][1]);
    }
}

test_vrn2_cells_space();