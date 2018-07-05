report = latexGenerator;

funcText = report.readFile('myTestFunc.m');
Name = {'M','L','R','r'};

helpInd = find(~cellfun(@isempty, regexp(funcText,'^\s*%')));
endInd = find(diff(helpInd)>1,1);
if ~isempty(endInd), helpInd = helpInd(1:endInd); end

helpText = funcText(helpInd);

defRegExp = '\s*%+\s*(\w+)\s*::\s*([\w]+)\s*::\s*(.+)$';
[defLines,defTokens] = regexp(helpText,defRegExp,'match','tokens');

defLines  = find(~cellfun(@isempty,defLines));
defStruct = struct();
defCount = 0;
for defLine = defLines
    defCount = defCount+1;
    defStruct(defCount).Name = strtrim(defTokens{defLine}{1}{1});
    defStruct(defCount).Type = strtrim(defTokens{defLine}{1}{2});
    defStruct(defCount).Description = strtrim(defTokens{defLine}{1}{3});
    addLineEnd = numel(helpText);
    if defCount < numel(defLines); addLineEnd = defLines(defCount+1)-1; end 
    for addLine = defLine+1:addLineEnd
        textLine = helpText{addLine};
        if isempty(regexp(textLine,'^\s*%+\s*$'))
            desToken = regexp(textLine,'^\s*%+\s*(.+)$','tokens');
            defStruct(defCount).Description = [ ...
                defStruct(defCount).Description,blanks(1),strtrim(desToken{1}{1})];
        else
            break
        end
    end
end
type = cell(size(Name));
description = cell(size(Name));
for k = 1:numel(Name)
    structInd = find(strcmp({defStruct(:).Name},Name{k}));
    type{k} = defStruct(structInd).Type;
    description{k} = defStruct(structInd).Description;
end

Name
type
    
    
    



    

