use <hull_polyline2d.scad>;
use <experimental/voronoi_lines.scad>;
use <experimental/convex_hull2.scad>;

pt_nums = 50;
width = 1;
points = [for(i = [0:pt_nums - 1]) rands(-50, 50, 2)];   

hull_pts = convex_hull2(points);
hull_polyline2d(
    concat(hull_pts, [hull_pts[0]]), 
    width = width, $fn = 4
);
  
intersection() {  
    for(line = voronoi_lines(points)) {
        hull_polyline2d(
            line, 
            width = width,
            $fn = 4
        );
    }
    
    polygon(hull_pts);
}

#for(p = points) {
    translate(p)
        circle(.5);
}