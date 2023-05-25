function digit_insert(ip,root,idx,mask)%输入十进制字符型ip地址、Trie树根节点、ip信息、十进制字符型掩码
temp=addr_to_bin(ip);%十进制IP地址转二进制
temp_digit=root;%从根节点开始插入
temp_idx=[];%与另一个地址有部分前缀冲突时需要暂存另一个ip信息
done=false;%判断是否完成ip信息插入
len=num_of_ones(mask);%掩码中的"1"的数量，即为需要存储的前缀长度
start=1;%下一个插入节点为空说明下一个节点位置已是能准确查到该IP的与根节点最近的位置，在下一节点的node_idx插入ip信息，设置其isend为true便于查找时跳出循环，start是已插入位数+1，start及之后的ip位直接插入即可
for k=1:1:len%掩码中的"1"的数量，即为需要存储的前缀长度
    if temp(k)=='0'%0对应左子树
        if isempty(temp_digit.left)
            if ~isempty(temp_idx)%digit_to_format非空说明与另一个地址有部分前缀冲突，此时ip地址在下一分支分离，将temp_dix存储的数据赋给右节点的node_idx，isend为true
                if ~isempty(temp_digit.right)
                    temp_digit.right.isend=true;
                    temp_digit.right.node_idx=temp_idx;
                else
                    temp_digit.isend=false;
                    temp_digit.node_idx=temp_idx;
                end
            end
            temp_digit.left=digit();%左节点为空，说明左节点位置已是能准确查到该IP的与根节点最近的位置
            temp_digit=temp_digit.left;
            temp_digit.isend=true;
            temp_digit.node_idx=idx;
            done=true;%完成ip信息插入
            start=k+1;%start及之后的ip位直接插入即可
            break;
        else
            temp_digit=temp_digit.left;%左节点非空直接左移
            if temp_digit.isend%如果该节点标志位为true，说明与另一个地址有部分前缀冲突，暂存另一个ip信息直到在下一分支分离，并将标志位设为false
                temp_digit.isend=false;
                temp_idx=temp_digit.node_idx;
                temp_digit.node_idx=[];
            end
        end
    else%"1"对应右子树
        if isempty(temp_digit.right)
            if ~isempty(temp_idx)
                if ~isempty(temp_digit.left)
                    temp_digit.left.isend=true;
                    temp_digit.left.node_idx=temp_idx;
                else
                    temp_digit.isend=false;
                    temp_digit.node_idx=temp_idx;
                end
            end
            temp_digit.right=digit();
            temp_digit=temp_digit.right;
            temp_digit.isend=true;
            temp_digit.node_idx=idx;
            done=true;
            start=k+1;
            break;
        else
            temp_digit=temp_digit.right;
            if temp_digit.isend
                temp_digit.isend=false;
                temp_idx=temp_digit.node_idx;
                temp_digit.node_idx=[];
            end
        end
    end
end

if ~done%如果遍历完前缀长度都与已有前缀冲突，说明该前缀被其他前缀包含或两者相同，该前缀最后端节点信息为该前缀信息
    temp_digit.node_idx=idx;
    if temp_idx
        if ~isempty(temp_digit.left)
            temp_digit.left.isend=true;
            temp_digit.left.node_idx=temp_idx;
        elseif ~isempty(temp_digit.right)
            temp_digit.right.isend=true;
            temp_digit.right.node_idx=temp_idx;
        end
    end
    return
end

for i=start:1:len%处理完标志位设立以及前缀冲突后，start及之后的ip位直接插入即可
    if temp(i)=='0'
        temp_digit.left=digit();
        temp_digit=temp_digit.left;
    else
        temp_digit.right=digit();
        temp_digit=temp_digit.right;
    end
end
end

function result=addr_to_bin(addr)%输入十进制字符型ip地址，输出二进制字符型ip地址
result=[];
start=1;
len=length(addr);
for i=1:1:len
    if addr(i)=='.'
        dec=str2double(addr(start:i-1));
        bin=dec2bin(dec,8);
        result=[result bin];
        start=i+1;
    end
end
dec=str2double(addr(start:len));%转换最后一个分隔符之后的数
bin=dec2bin(dec,8);
result=[result bin];
end

function result=num_of_ones(mask)%输入十进制字符型掩码，输出二进制字符型掩码包含的"1"的数量
result=0;
len=length(mask);
start=1;
for i=1:1:len
    if mask(i)=='.'
        dec=str2double(mask(start:i-1));
        bin=dec2bin(dec,8);
        for k=1:1:8
            if bin(k)=='1'
                result=result+1;
            end
        end
        start=i+1;
    end
end
dec=str2double(mask(start:len));%转换最后一个分隔符之后的数,找出"1"并累加"1"的数量
bin=dec2bin(dec,8);
for k=1:1:8
    if bin(k)=='1'
        result=result+1;
    end
end
end