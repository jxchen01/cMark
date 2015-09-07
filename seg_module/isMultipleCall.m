function flag=isMultipleCall()
s = dbstack();
% s(1) corresponds to isMultipleCall
if numel(s)<=2, flag=false; return; end
% compare all functions on stack to name of caller
count = sum(strcmp(s(2).name,{s(:).name}));
% is caller re-entrant?
if count>1, flag=true; else flag=false; end