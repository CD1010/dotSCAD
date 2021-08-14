use <shape_circle.scad>;
use <bezier_curve.scad>;
use <sweep.scad>;
use <path_scaling_sections.scad>;
use <bijection_offset.scad>;
use <util/rand.scad>;
use <noise/nz_worley3s.scad>;

beginning_radius = 30;
height = 200;
thickness = 2;
fn = 180;
amplitude = 20;
curve_step = 0.01;
smoothness = 30;
dist = "border"; // [euclidean, manhattan, chebyshev, border]

bottom = "YES"; // ["YES", "NO"]
epsilon = 0.0000001;

worley_vase(beginning_radius, height, fn, amplitude, curve_step, smoothness, dist, bottom, epsilon);

module worley_vase(beginning_radius, height, fn, amplitude,curve_step, smoothness, dist, bottom, epsilon) {
    grid_width = 1.25;
    seed = rand() * 1000;
	section = shape_circle(radius = beginning_radius, $fn = fn);
	pt = [beginning_radius, 0, 0];
    h_s = height / 140;
	edge_path = bezier_curve(curve_step, [
		pt,
		pt + [15, 0, 20 * h_s],
		pt + [55, 0, 50 * h_s],
		pt + [20, 0, 70 * h_s],
		pt + [5, 0, 80 * h_s],
		pt + [-5, 0, 100 * h_s],
		pt + [10, 0, 140 * h_s]
	]);

	sections = path_scaling_sections(section, edge_path);

	noisy = [
		for(section = sections)
		let(nz = nz_worley3s(section / smoothness, seed, grid_width, dist))
		[
			for(i = [0:len(nz) - 1])
			let(
				p = section[i],
				p2d = [p[0], p[1]],
				noisyP = p2d + p2d / norm(p2d) * nz[i][3] * amplitude
			)
			[noisyP[0], noisyP[1], p[2]]
		]
	];
	
	offset_noisy = [
		for(section = noisy)
		let(
			offset_s = bijection_offset(section, thickness, epsilon)
		)
		[
			for(i = [0:len(offset_s) - 1])
			[offset_s[i][0], offset_s[i][1], section[i][2]]
		]
	];

	all = [
		for(i = [0:len(offset_noisy) - 1])
		concat(
			offset_noisy[i],
			noisy[i]
		)
	];

	sweep(all, triangles = "HOLLOW");
	
	if(bottom == "YES") {
	    sweep([
			for(section = noisy)
			if(section[0][2] < thickness) 
			section
		]);
	}
}