function Cons = consTree(cons,n, Csum)
Cons.cons = cons;
dic = containers.Map('KeyType', 'int32', 'ValueType', 'any');
dict = containers.Map('KeyType', 'int32', 'ValueType', 'any');
if isempty(cons) == 0
    Cons.dic = dic;
    Cons.idx =[];
    Cons.dict = dict;
    return
end



for i = 1:n
    dict(i) = [];
end
consCount = zeros(1,n);
n = length(cons);
for i = 1:n
    con = cons{i};
    consCount(con(1)) = consCount(con(1)) + 1;
    consCount(con(2)) = consCount(con(2)) + 1;
    dict(con(1)) = [dict(con(1)); con(2) con(3) con(4)];
    dict(con(2)) = [dict(con(2)); con(1) con(3) con(4)];
end
idx = 1:n;
idx = idx(consCount>0);
[idx, forceRank] = sort(vecnorm(Csum(idx)));
list = 1:n;
fifo = [idx(1)];
while ~isempty(fifo) || ~isempty(list)
    if ~isempty(fifo)
        cur = fifo(1);
        fifo = fifo(2:end);
        tmp = dict(cur);
        
        if ~isempty(tmp)
            tmp = tmp(:,1)';
            % disp(dic.keys)
            if sum(ismember(tmp, cell2mat(dic.keys))) > 1
                error('loop constraints')
            end
        end
        dic(cur) = tmp(ismember(tmp, list));
        list = list(~ismember(list, cur));
        fifo = [fifo dic(cur)];
    else
        fifo = [fifo list(1)];
    end
end

Cons.dic = dic;
Cons.idx = idx;
Cons.dict = dict;





