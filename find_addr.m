function [result,num]=find_addr(addr,root)%输入十进制字符型ip地址、Trie树根节点输出ip信息
temp=addr_to_bin(addr);%十进制IP地址转二进制
temp_digit=root;%从根节点开始查找
result=[];%查找到标志位后，将其ip信息node_idx赋给result
len=length(temp);%二进制IP地址长度
num=0;%测试用
start=1;
temp_IP=[];
for k=1:1:len
    num=num+1;
    if temp(k)=='1'%"1"对应右子树
        if ~isempty(temp_digit.right)
            temp_digit=temp_digit.right;
            if ~isempty(temp_digit.node_idx)%有值但是标志位为false，说明存在包含关系，此时采取最长前缀匹配算法，跳出循环
                if temp_digit.isend%遇到标志位结束函数
                    result=temp_digit.node_idx;
                    return
                end
                result=temp_digit.node_idx;
                start=k+1;
                break;
            end
            if temp_digit.isend%遇到标志位结束函数
                result=temp_digit.node_idx;
                return
            end
        end
    else%"0"对应左子树
        if ~isempty(temp_digit.left)
            temp_digit=temp_digit.left;
            if ~isempty(temp_digit.node_idx)
                if temp_digit.isend
                    result=temp_digit.node_idx;
                    return
                end
                result=temp_digit.node_idx;
                start=k+1;
                break;
            end
        end
    end
end

for i=start:1:len%最长前缀匹配,直到查询到空节点结束函数
    num=num+1;
    if temp(i)=='1'%"1"对应右子树
        if ~isempty(temp_digit.right)
            temp_digit=temp_digit.right;

            if ~isempty(temp_digit.node_idx)
                if temp_digit.isend
                    temp_IP=temp_digit.node_idx;
                else
                    result=temp_digit.node_idx;
                end
            end
        else
            break;
        end
    else%"0"对应左子树
        if ~isempty(temp_digit.left)
            temp_digit=temp_digit.left;
            if ~isempty(temp_digit.node_idx)
                if temp_digit.isend
                    temp_IP=temp_digit.node_idx;
                else
                    result=temp_digit.node_idx;
                end
            end
        else
            break;
        end
    end
end

if ~isempty(temp_IP)
    if isempty(temp_digit.left)&&isempty(temp_digit.right)
        result=temp_IP;
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
        start=i+1;%start是最后一个分隔符号"."的位数+1
    end
end
dec=str2double(addr(start:len));%转换最后一个分隔符之后的数
bin=dec2bin(dec,8);
result=[result bin];
end
