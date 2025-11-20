function res = bt_add(btA, btB)

  tables = make_tables();

  lenA = length(btA);
  lenB = length(btB);
  len = max(lenA, lenB);

  % pad shorter string
  btA = pad_left(btA, len - lenA);
  btB = pad_left(btB, len - lenB);

  res = repmat('0', 1, len);
  carry1 = repmat('0', 1, len+1);
  carry = repmat('0', 1, len+1);

  % addition loop
  for i = len:-1:1
%      disp(carry(i+1))
      tmp1 = bt_lookup('+', carry(i+1), btA(i), tables);
%      disp(tmp1)

      if length(tmp1) == 1
          carry1(i) = '0';
      else
          carry1(i) = tmp1(1); % carry1
      end

      tmp  = bt_lookup('+', tmp1(end), btB(i), tables);
%      disp(tmp)
%      disp('+++')

      if length(tmp) == 1
          res(i) = tmp;
          carry(i) = '0';
      else
          res(i) = tmp(2);   % digit
          carry(i) = tmp(1); % carry
      end

      %combine carries
      cr = bt_lookup('+', carry1(i), carry(i), tables);
      carry(i) = cr;

  end

  % prepend final carry if non-zero
  if carry(1) ~= '0'
      res = [carry(1), res];
  end

end

