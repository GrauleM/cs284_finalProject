syms x
f = cos(x)/sqrt(1 + x^2);
fInt = int(f,x,[0 10])
fVpa = vpa(fInt)