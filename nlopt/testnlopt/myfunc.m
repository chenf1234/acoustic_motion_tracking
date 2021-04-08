function [val, gradient] = myfunc(x,a,b,c)
    %disp(a);disp(b);disp(c);
    val = sqrt(x(2));
    if (nargout > 1)
        gradient = [0 0.5 / val];
    end
end

