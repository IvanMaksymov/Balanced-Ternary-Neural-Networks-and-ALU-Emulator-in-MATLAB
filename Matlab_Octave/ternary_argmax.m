function cls = ternary_argmax(v)
    mx = max(v);
    idxs = find(v==mx);

    if length(idxs)==1
        cls = idxs-1;
    else
        % tie
        % leftmost wins
        cls = idxs(1)-1;

        %random pick
        %j = randi(length(idxs));
        %cls = idxs(j)-1;

    end
end

