use <../../util/sort.scad>;

function _sum_impl(lt, leng, i = 0) =
    i >= leng - 1 ? lt[i] : (lt[i] + _sum_impl(lt, leng, i + 1));

function sum(lt) = _sum_impl(lt, len(lt));

function _manhattan(v) = sum([for(d = v) abs(d)]);

function _chebyshev(p1, p2) =
    max([for(i = [0:len(p1) - 1]) abs(p1[i] - p2[i])]); 

function _nz_cell_classic(cells, p, dist) =
    let(
        dists = [
            for(i = [0:len(cells) - 1])
                dist == "euclidean" ? norm(cells[i] - p) :
                dist == "manhattan" ? _manhattan(cells[i] - p) :
                dist == "chebyshev" ? _chebyshev(cells[i], p) :
                             assert("Unknown distance option")
        ]
    )
    min(dists); 

function _nz_cell_border(cells, p) =
    let(
        dists = [
            for(i = [0:len(cells) - 1])
                [each cells[i], norm(cells[i] - p)]
        ],
        idx = len(cells[0]),
        sorted = sort(dists, by = "idx", idx = idx),
        a = [for(i = [0:idx - 1]) sorted[0][i]],
        b = [for(i = [0:idx - 1]) sorted[1][i]],
        m = (a + b) / 2
    )
    (p - m) * (a - m);