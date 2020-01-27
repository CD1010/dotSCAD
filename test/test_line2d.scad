use <unittest.scad>;
use <line2d.scad>;

module test_line2d() {
    $fn = 24;
    p1 = [0, 0];
    p2 = [5, 0];
    width = 1;    

    echo("==== test_line2d_cap_square ====");
    

    module test_line2d_cap(point, style) {
        assert(
            (point == p1 && style == "CAP_SQUARE") ||
            (point == p2 && style == "CAP_SQUARE")
        );
    }
    
    module test_line2d_line(angle, length, width, frags) {
        assertEqualNum(0, angle);
        assertEqualNum(5, length);
        assertEqualNum(1, width);
        assertEqualNum(24, frags);
    }     
    
    line2d(p1 = p1, p2 = p2, width = width); 
}

test_line2d();

