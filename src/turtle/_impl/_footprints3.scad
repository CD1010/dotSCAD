use <../turtle3d.scad>;

function _footprints3(cmds, t, leng, i = 0) =
    i == leng ? [] :
        let(
            nxt = turtle3d(cmds[i][0], t, cmds[i][1]),
            pts = _footprints3(cmds, nxt, leng, i + 1)
        )
        cmds[i][0] != "forward" ? pts : [turtle3d("pt", nxt), each pts];
