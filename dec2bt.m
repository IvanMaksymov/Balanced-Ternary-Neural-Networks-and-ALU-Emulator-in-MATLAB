function bt = dec2bt(x)
    if x == 0, bt = "0"; return; end
    num = x; digits = [];
    while num ~= 0
        r = mod(num,3); num = floor(num/3);
        if r == 2, r=-1; num=num+1; end
        digits = [r digits];
    end
    bt = "";
    for d=digits
        if d==-1, bt=[bt 'T'];
        elseif d==0, bt=[bt '0'];
        else bt=[bt '1'];
        end
    end
end
