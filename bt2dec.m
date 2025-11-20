function x = bt2dec(bt)
    x=0; n=length(bt);
    for k=1:n
        if bt(k)=='T', d=-1; elseif bt(k)=='0', d=0; else d=1; end
        x = x + d*3^(n-k);
    end
end
