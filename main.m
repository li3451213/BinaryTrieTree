clear
clc
root=digit();
iplist={'192.0.0.2' '240.0.0.0';
    '96.128.0.2' '255.192.0.0';
    '192.64.0.2' '255.192.0.0';
    '192.128.0.2' '255.192.0.0';
    '96.0.0.2' '240.0.0.0' };
[row,col]=size(iplist);
for k=1:1:row
    digit_insert(iplist{k,1},root,k,iplist{k,2});
    fprintf('存储地址%s及其ip信息%d\n',iplist{k,1},k);
end
for k=1:1:row
    [result,n]=find_addr(iplist{k,1},root);
    fprintf('查寻到地址%s的ip信息为%d\n',iplist{k,1},result);
end