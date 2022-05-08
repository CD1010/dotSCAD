use <_lsystem_comm.scad>;
use <../turtle3d.scad>;

function _lsystem3_join(str_lt) = _join(str_lt);

function _lsystem3_derive(axiom, rules, n, rule_prs) =
    is_undef(rule_prs) ? _derive(axiom, rules, n) :
                         _derive_p(axiom, rules, rule_prs, n);

function _next_stack(t, code, stack) = 
    code == "[" ? [t, each stack] :
    let(leng = len(stack))
    code == "]" ? 
            (leng > 1 ? [for(i = [1:leng - 1]) stack[i]] : []) :
            stack;

function _next_t1(t1, t2, code, stack) = 
    code == "[" ? t1 : 
    code == "]" ? stack[0] : t2; 
    
function _next_t2(t, code, angle, leng) = 
    is_undef(code) || code == "[" || code == "]" ? t :
    code == "F" || code == "f" ? turtle3d("forward", t, leng) :
    code == "+"  ? turtle3d("turn", t, angle) :
    code == "-"  ? turtle3d("turn", t, -angle) : 
    code == "|"  ? turtle3d("turn", t, 180) :   
    code == "&"  ? turtle3d("pitch", t, -angle) :        
    code == "^"  ? turtle3d("pitch", t, angle) :
    code == "\\" ? turtle3d("roll", t, angle) :             
    code == "/"  ? turtle3d("roll", t, -angle) : t;       

// It doesn't use recursion to avoid recursion error.    
function _lines(t, codes, angle, leng) = 
    let(codes_leng = len(codes))
    [
        for(
            i = 0,
            stack = [],            
            t1 = t, 
            t2 = _next_t2(t1, codes[i], angle, leng);
            
            i < codes_leng; 
            
            t1 = _next_t1(t1, t2, codes[i], stack), 
            stack = _next_stack(t1, codes[i], stack),
            i = i + 1, 
            t2 = _next_t2(t1, codes[i], angle, leng)
        )
        let(p1 = turtle3d("pt", t1), p2 = turtle3d("pt", t2))
        if(search(codes[i], "F+-") != [] && p1 != p2)
            [turtle3d("pt", t1), turtle3d("pt", t2)]
    ];