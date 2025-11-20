function out = bt_negate(bt)
  % Negate an arbitrary balanced ternary number (string)

  n = length(bt);
  out = repmat('0', 1, n);

  for i = 1:n
    c = bt(i);
    if c == '1'
      out(i) = 'T';
    elseif c == 'T'
      out(i) = '1';
    else
      out(i) = '0';
    endif
  end

end

