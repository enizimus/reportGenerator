classdef reportGenerator < handle
    
    properties
    end
    
    properties (Access = protected)
        setting = containers.Map('KeyType','char','ValueType','char')
        outputText = {}
        settingDefault = containers.Map('KeyType','char','ValueType','char')
        textBlock = struct();
        codeBlock = struct();
        insertLine = 1
        settingSeparator = '::'
        keyWordMarker = '+'
        counter = struct()
    end
    
    methods
        
        function set(obj,varargin)
            for k = 1:2:numel(varargin)
                key = varargin{k};
                value = varargin{k+1};
            
                if isnumeric(value) && isscalar(value)
                    value = num2str(value);
                elseif isnumeric(key)
                    value = mat2str(value);
                end
                try
                    obj.setting(key) = value;
                catch err
                    warning(['Key ',key,' can not be set!'])
                end 
            end
        end % set

        function value = get(obj,key,varargin)
            value = '';
            try 
                value = obj.setting(key);
                if isempty(value) && numel(varargin)>0
                    value = varargin{1}; % default
                end
                if numel(varargin)>1
                    try 
                        value  = varargin{2}(value);
                    catch err2
                    end
                end
            catch err
                warning(['Key ',key,' does not exist in setting!'])
            end
        end % get.setting
                   
        function setDefault(obj,varargin)
            for k = 1:numel(varargin)
                key = varargin{k};
                switch key
                    case {'all'}
                        settingKeys = keys(obj.settingDefault);
                    case {'table','tabular'}
                        settingKeys = {'tablePlacement','transposeTable','dataFormatMode', ...
                            'dataFormat','dataNanString','tableColumnAlignment','tableBorders', ...
                            'booktabs','centerTabular','tableColLabels','tableRowLabels' ...
                            };
                    case {'text'}
                        settingKeys = {'shiftTextUnit','shiftText','separateText'};
                    case {'disp','display'}
                        settingKeys = {'dispLatexCode'};
                    case {'image','figure'}
                        settingKeys = {'imagePerLine','imageOption','figureOption','figurePlacement', ...
                            'trimImage','borderImage','trimImageCommand','borderImageCommand'};
                    case {'array','arrayImage'}
                        settingKeys = {'arrayImageColor','arrayColorbar'};
                    case {'pretty','output'}
                        settingKeys = {'prettyComMax','prettyMaxSize','prettyMaxShow', ...
                            'prettyMaxShowFac','prettyMinShow' ...
                            };
                    otherwise
                        settingKeys = {key};
                end
                for ks = 1:numel(settingKeys)
                    obj.setting(settingKeys{ks}) = obj.settingDefault(settingKeys{ks});
                end
            end
        end % setDefault
        
        function fileName = getFileName(obj,type)
            switch type
                case {'outputFile','output'}
                    fileName = [obj.get('outputFile'),'.',obj.get('outputFormat')];
                case {'reportFile','report'}
                    fileName = [obj.get('outputFile'),'.',obj.get('reportFormat')];
                case {'settingFile','setting'}
                    fileName = [obj.get('settingFile')];
                case {'templateFile','template'}
                    fileName = [obj.get('templateFile'),'.',obj.get('outputFormat')];
                case {'textBlockFile','textBlock'}
                    fileName = [obj.get('textBlockFile'),'.',obj.get('outputFormat')];
                case {'codeBlockFile','codeBlock'}
                    fileName = [obj.get('codeBlockFile'),'.m'];
                case {'matlabInitFile','matlabInit'}
                    fileName = [obj.get('matlabInitFile'),'.m'];
            end
        end
        
        function var = wrapInCell(obj,var)
            if ~iscell(var), var = {var}; end
        end % wrapInCell
            
        function var = wrapOutCell(obj,var)
            if iscell(var), var = var{1}; end
        end % wrapOutCell

        function cText = readFile(~,fileName)
            fid = fopen(fileName,'r');
            k = 0;
            while true
                tline = fgetl(fid);
                if ~ischar(tline), break, end
                k = k + 1;
                cText{k} = tline;
            end
            fclose(fid);
        end % readFile
        
        function export(obj)
            fileName = obj.getFileName('output');
            fid = fopen(fileName,'w');
            for k = 1:numel(obj.outputText)
                tline = obj.outputText{k};
                if ischar(tline), fprintf(fid,'%s\n',tline); end
            end
            fclose(fid);
        end % export
        
        function generate(obj)
            fileName = obj.getFileName('output');
            systemCommand = [obj.get('outputGenerator'),' ',fileName];

            if exist(obj.get('outputGenerator'))
                disp(['Running ',systemCommand])
                eval([systemCommand]);
                disp(['Running End'])
            else
                disp(['Running ',systemCommand])
                [status,cmdout] = system([systemCommand]);
                disp(['Running End'])
                % obj.runMatlabInit('deinit')
                if status>0, cmdout, end
                if status>0, error(['Problem to generate output: Status ',num2str(status)]), end
            end
        end % generate
        
        function view(obj)
            fileName = obj.getFileName('report');
            systemCommand = [obj.get('outputViewer'),' ',fileName];
            [status,cmdout] = system(systemCommand);
        end % view
        
        function cleanMediaDir(obj)
            if exist(obj.get('mediaDir'),'dir')
                delete([obj.get('mediaDir'),'/','*'])
            end
        end % cleanMediaDir
                
        function addText(obj,text,emptyLine,keyWord)
            if nargin<3 || isempty(emptyLine), emptyLine = true; end
            if ~iscell(text), text = {text}; end
            if emptyLine, text = [text,{' '}]; end
            if nargin < 4
                obj.outputText = [obj.outputText(1:obj.insertLine-1), ...
                    text, obj.outputText(obj.insertLine:end)];
                obj.insertLine = obj.insertLine + numel(text);
            else
                line = obj.searchKeyWord(keyWord);
                if ~isempty(line)
                    obj.outputText = [obj.outputText(1:line-1), ...
                        text, obj.outputText(line+1:end)];
                    obj.insertLine = obj.insertLine + numel(text)-1;
                end
            end 
        end % addText
        
        function initSetting(obj,p)
            res = p.Results;
            resNames = fieldnames(res);
            for k = 1:numel(resNames)
                obj.setting(resNames{k}) = res.(resNames{k});
            end
            obj.readSetting;
            % repeat to overwrite settings with input from command line
            for k = 1:numel(resNames)
                obj.setting(resNames{k}) = res.(resNames{k});
            end
            settingKeys = keys(obj.setting);
            for k = 1:numel(settingKeys)
                obj.settingDefault(settingKeys{k}) = obj.setting(settingKeys{k});
            end
        end % initSetting
        
        function readSetting(obj)
            fileName = obj.getFileName('setting');
            cText = obj.readFile(fileName);
            for k = 1:numel(cText)
                tline = cText{k};
                cSet = strsplit(tline,obj.settingSeparator);
                cSet = cellfun(@strtrim,cSet,'Uni',0);
                obj.setting(cSet{1}) = cSet{2};
            end
        end % readSetting

        function varargout = readTextBlock(obj,fileName)
            if nargin < 2 || isempty(fileName)
                fileName = obj.getFileName('textBlock');
            else
                myStruct = struct();
            end
            cText = obj.readFile(fileName);
            [start,tokens] = regexp(cText,['^',obj.get('blockSeparator'),'\s*(\w+)'],'start','tokens');
            ind = find(~cellfun(@isempty,start));
            ind = [ind,numel(cText)+1];
            for c = 1:numel(ind)-1
                token = tokens{ind(c)}{1}{1};
                if exist('myStruct','var')
                    myStruct.(token) = cText(ind(c)+1:ind(c+1)-1);
                else
                    obj.textBlock.(token) = cText(ind(c)+1:ind(c+1)-1);
                end
            end
            if nargout > 0 && exist('myStruct','var')
                varargout{1} = myStruct;
            elseif nargout > 0
                varargout{1} = '';
            end
            
        end % readTextBlock
            
        function varargout = readCodeBlock(obj,fileName)
            if nargin < 2 || isempty(fileName)
                fileName = obj.getFileName('codeBlock');
            else
                fileName = [fileName,'.m'];
                myStruct = struct();
            end
            
            cText = obj.readFile(fileName);
            [start,tokens] = regexp(cText,['^',obj.get('blockSeparator'),'\s*(\w+)'],'start','tokens');
            ind = find(~cellfun(@isempty,start));
            ind = [ind,numel(cText)+1];
            for c = 1:numel(ind)-1
                token = tokens{ind(c)}{1}{1};
                if exist('myStruct','var')
                    myStruct.(token) = cText(ind(c)+1:ind(c+1)-1);
                else
                    obj.codeBlock.(token) = cText(ind(c)+1:ind(c+1)-1);
                end
            end
            if nargout > 0 && exist('myStruct','var')
                varargout{1} = myStruct;
            elseif nargout > 0
                varargout{1} = '';
            end
        end % readCodeBlock
        
        function line = searchKeyWord(obj,key)
            line = find(~cellfun(@isempty,strfind(obj.outputText, ...
                [obj.keyWordMarker,key,obj.keyWordMarker] ...
                )));            
        end % searchKeyWord
        
        function replaceKeyWord(obj,key,value)
            key = [obj.keyWordMarker,key,obj.keyWordMarker];
            obj.outputText = strrep(obj.outputText,key,value);
        end % replaceKeyWord
        
        function readTemplate(obj)
            fileName = obj.getFileName('template');
            try
                obj.outputText = obj.readFile(fileName);
            catch err
                obj.outputText = {''};
            end
            try
                obj.insertLine = obj.searchKeyWord('CONTENT');      
            catch err
                obj.insertLine = 1;
            end
            if isempty(obj.insertLine), obj.insertLine=1; end
            obj.outputText(obj.insertLine) = '';
        end % readTemplate
        
        function val = increaseCounter(obj,name)
            if ~isfield(obj.counter,name), obj.counter.(name) = 0; end
            obj.counter.(name) = obj.counter.(name) + 1;
            val = obj.counter.(name);
        end % increaseCounter

        function val = decreaseCounter(obj,name)
            if ~isfield(obj.counter,name), obj.counter.(name) = 0; end
            obj.counter.(name) = obj.counter.(name) - 1;
            val = obj.counter.(name);
        end % decreaseCounter

        function val = getCounter(obj,name)
            if ~isfield(obj.counter,name), obj.counter.(name) = 0; end
            val = obj.counter.(name);
        end % getCounter
        
        
        function runMatlabInit(obj,action)
            if nargin < 2 || isempty(action), action = 'init'; end
            fileName = obj.getFileName('matlabInit');
            matlabCode = obj.readFile(fileName);
            switch action
                case 'init'
                    obj.addMatlab(matlabCode,{'eval'}) 
                case 'deinit'
                    rExp = '^\s*set\s*\((\w+)\s*,''default(\w+)';
                    tokens = regexp(matlabCode,rExp,'ignorecase','tokens');
                    deinitCode = {};
                    count = 0;
                    for k = 1:numel(tokens)
                        if ~isempty(tokens{k}) && numel(tokens{k}{1})==2
                            count = count+1;
                            deinitCode{count} = ['set(',tokens{k}{1}{1},',''default',tokens{k}{1}{2},''',''default'')'];
                        end
                    end
                    obj.addMatlab(deinitCode,{'eval'})    
            end
        end % runMatlabInit
        
        function varargout = addParagraph(obj,paragraphs)
            paragraphs = obj.wrapInCell(paragraphs);
            text = {};
            for k = 1:numel(paragraphs)
                paragraph = paragraphs{k};
                if exist(paragraph,'file')
                    paragraph = obj.readFile(paragraph);
                elseif isfield(obj.textBlock,paragraph)
                    paragraph = obj.textBlock.(paragraph);
                else
                    paragraph = obj.wrapInCell(paragraph);
                end
                text = [text,paragraph];
            end
            if nargout == 0
                obj.addText(text);
            else
                varargout{1} = text;
            end
        end % addParagraph
        
        function addEmptyPage(obj)
            obj.addText({'\newpage','\makebox[10mm][l]{}','\newpage'}); 
        end % addEmptyPage
        
        function addNewPage(obj)
            obj.addText({'\newpage'}); 
        end % addNewPage
        
        function addVerticalSpace(obj,amount)
            obj.addText({['\vspace*{',amount,'}']},0)
        end % addVerticalSpace
        
        function addMatlab(obj,code,actions,shiftAmount,startLine,endLine)
            if nargin < 4 || isempty(shiftAmount), shiftAmount = 1; end

            code    = obj.wrapInCell(code);
            actions = obj.wrapInCell(actions);  
            
            if exist(code{1},'file')
                code = obj.readFile(code{1}); 
            elseif isfield(obj.codeBlock,code{1})
                code = obj.codeBlock.(code{1});
            end

            if nargin < 5 || isempty(startLine), startLine = 1; end
            if nargin < 6 || isempty(endLine), endLine = numel(code); end
            
            for ka = 1:numel(actions)
                action = actions{ka};
                switch action
                    case 'eval'
                        comString = '';
                        for kc = startLine:endLine %1:numel(code)
                            newString = strtrim(regexprep(code{kc},'%.+$',''));
                            if ~isempty(newString)
                                if ~isempty(regexp(newString,'\.\.\.$'))
                                    newString = strrep(newString,'...','');
                                elseif ~any(strcmp(newString(end),{',',';'}))
                                    newString = [newString,';']; 
                                end
                                comString = [comString,newString];
                            end
                        end
                        evalin('base',comString)
                    case 'listing'
                        obj.addListing(code,shiftAmount,startLine,endLine)
                end
            end
        end % addMatlab
            
        function figNames = createFigureImage(obj,figHandles)
            
            if ~exist(obj.get('mediaDir'),'dir')
                mkdir(obj.get('mediaDir'))
            end
            figNames = cell(1,numel(figHandles));
            for k=1:numel(figHandles)
                figHandle = figHandles(k);
                count = num2str(obj.increaseCounter('picture'));
                fileName = [obj.get('mediaDir'),'/', ...
                    obj.get('mediaPrefix'),count,'.', ...
                    obj.get('mediaFormat')];
                figNames{k} = fileName;
                %eStr = ['print(figHandles(',num2str(k), '), -d',obj.get('mediaFormat'),', ',fileName,')']
                print(figHandle,['-d',obj.get('mediaFormat')],fileName);
                if obj.get('trimImage',0,@str2num)
                    eStr = strrep(obj.get('trimImageCommand'),'#FILE#',fileName);
                    system(eStr);
                end
                if obj.get('borderImage',0,@str2num)
                    eStr = strrep(obj.get('borderImageCommand'),'#FILE#',fileName);
                    system(eStr);
                end
            end
        end % createFigureImage

        function figNames = getFigureNames(obj,images)        
            images = obj.wrapInCell(images); 
            figNames = {};
            for k = 1:numel(images)
                image = images{k};
                if isa(image,'matlab.ui.Figure')
                    newFigNames = obj.createFigureImage(image);
                    figNames = [figNames,newFigNames];
                else
                    if ~exist(image,'file')
                        image = [obj.get('mediaDir'),'/',image];
                    end
                    if ~exist(image,'file')
                        error(['image ',image,' does not exist!'])
                    end
                    figNames = [figNames,image];
                end
            end
        end % getFigureNames
            
        function text = shiftText(obj,text,amount)
            if nargin < 3 || isempty(amount)
                amount = obj.get('shiftText',1,@str2num);
            end
            shiftTextUnit = obj.get('shiftTextUnit',4,@str2num);
            text = cellfun(@(x) [repmat(blanks(shiftTextUnit),1,amount),x], text, 'Uni',0);
        end % shiftText
        
        function text = equalLineLengthText(~,text)
            maxLength = max(cellfun(@numel,text));
            text = cellfun(@(x) [x,blanks(maxLength-numel(x))], text, 'Uni',0);
        end % equalLineLengthText
            
        function text = horzcatText(obj,text1,text2,amount)            
            if nargin < 4 || isempty(amount) 
                amount = str2num(obj.get('separateText'));
            end
            text1 = [text1,repmat({''},1,numel(text2)-numel(text1))];
            text2 = [text2,repmat({''},1,numel(text1)-numel(text2))];
            text1 = obj.equalLineLengthText(text1);
            text2 = obj.shiftText(text2,amount);
            text = cellfun(@(x,y) [x,y], text1, text2, 'Uni',0);
        end % horzcatText
            
        function dispLatexCode(obj,text)
            if obj.get('dispLatexCode',0,@str2num);
                sep = repmat('-',1,80);
                fprintf('%s\n',sep)
                if iscell(text)
                    fprintf('%s\n',text{:})
                elseif ischar(text)
                    fprintf('%s\n',text)
                end
                fprintf('%s\n',sep)
            end
        end % dispLatexCode
        
        function outText = createPrettyMatrixOutput(obj,variables,latex,compact)
            if nargin < 3 || isempty(latex), latex = false; end
            if nargin < 4 || isempty(compact), compact = false; end
            variables = obj.wrapInCell(variables);
            comMax = obj.get('prettyComMax',[],@str2num);
            maxSize = obj.get('prettyMaxSize',[],@str2num);
            maxShow = obj.get('prettyMaxShow',[],@str2num);
            maxShowFac = obj.get('prettyMaxShowFac',[],@str2num);
            minShow = obj.get('prettyMinShow',[],@str2num);

            for k = 1:numel(variables)
                var = evalin('base',variables{k});  
                
              [text,info] = mltutorShrinkOutput(var,comMax,maxSize,maxShow,maxShowFac,minShow,latex);
                
                if latex
                    text = strrep(text,'$$','');
                    % text = ['\verb|',variables{k},'| = ',text];
                    name = variables{k};
                    name = strrep(name,'_','\_');
                    text = ['{\tt ',name,'}',' = ',text];
                    if k == 1
                        outText = text;
                    else
                        outText = [outText,'\;\;\;\;\;',char(10),text];
                    end
                    if k == numel(variables)
                        
                        if ~isa(obj,'latexGenerator') % isempty(latexOutputColor)
                            outText = ['$$',char(10),outText,'$$'];
                        else
                            latexOutputColor = obj.get('latexOutputColor');
                            outText = ['$$\textcolor{',latexOutputColor,'}{',char(10),outText,'}$$'];
                        end
                        outText = strsplit(outText,char(10));
                        L = ~cellfun(@isempty,outText);
                        outText = outText(L);
                    end
                    
                else
                    if strcmp(text(end),char(10)), text = text(1:end-1); end
                    text = strrep(text,'NaN','nan');
                    if compact
                        if isempty(strfind(text,char(10)))
                            text = regexprep(strtrim(text),'[ ]+',',');
                            text = [variables{k},'=[',text,']'];
                        else
                            pre = [variables{k},'=['];
                            text=[pre,text];
                            text = strrep(text,char(10),[' ;',char(10),blanks(numel(pre))]);
                            text = [text,' ]'];
                        end
                    else
                        text=[variables{k},' = ',char(10),' ',char(10),text];
                    end
                    text = strsplit(text,char(10));
                    
                    if k == 1
                        outText = text;
                    else
                        outText = obj.horzcatText(outText,text);
                    end
                end
            end
        end % createPrettyMatrixOutput

        function addMatlabOutput(obj,variables,latex,compact)
            if nargin < 3 || isempty(latex), latex = false; end
            if nargin < 4 || isempty(compact), compact = false; end
            outText = obj.createPrettyMatrixOutput(variables,latex,compact);
            
            if latex
                obj.addText(outText);
            else
                obj.set('listingBasicStyle',obj.get('listingOutputStyle'))
                obj.addListing(outText);
                obj.setDefault('listingBasicStyle')
            end
            
            
            
        end % addMatlabOutput
        
        function imageNames = createArrayImage(obj,arrays)
            arrayImageColor = obj.get('arrayImageColor',0,@str2num);
            arrayColorbar = obj.get('arrayColorbar',1,@str2num);
            trimImage = obj.get('trimImage');
            borderImage = obj.get('borderImage');
            obj.set('trimImage',1)
            obj.set('borderImage',1);
            
            arrays = obj.wrapInCell(arrays);
            imageNames = {};
            for ka = 1:numel(arrays)
                array = arrays{ka};
                array = obj.wrapInCell(array);
                vars = cell(1,numel(array));
                for kv = 1:numel(array)
                    vars{kv} = evalin('base',array{kv});
                end
                figure;
                if arrayImageColor
                    ah = showmata(vars{:});
                else
                    ah = showmatabw(vars{:});
                end
                figureHandle = get(ah(1),'Parent');
                if ~arrayColorbar
                    cb = findobj(figureHandle,'Type','Colorbar');
                    delete(cb)
                end
                figNames = createFigureImage(obj,figureHandle);
                imageNames = [imageNames,figNames];
            end
            obj.set('trimImage',trimImage)
            obj.set('borderImage',borderImage);
        end % createArrayImage
        
        function addFunctionDescription(obj,func,type,description,pre,post)
            
            if nargin < 5 || isempty(pre),  pre  = ''; end 
            if nargin < 6 || isempty(post), post = ''; end 

            regExp = '^\s*function\s*\[?([\w ,]+)\]?\s*=\s*(\w+)\s*\((.+)\)';
            
            if exist(func,'file')
                funcText = obj.readFile(func);
                L = ~cellfun(@isempty,regexp(funcText,regExp));
                func = obj.wrapOutCell(funcText(L));
            end
            toks = regexp(func,regExp,'tokens');
            parameterOut = toks{1}{1};
            parameterOut = cellfun(@strtrim,strsplit(parameterOut,','),'Uni',0).';
            funcName = toks{1}{2};
            parameterIn = toks{1}{3};
            parameterIn = cellfun(@strtrim,strsplit(parameterIn,','),'Uni',0).';
            numOut = numel(parameterOut);
            numIn = numel(parameterIn);
            
            InOut = [repmat({'Input'},numIn,1);repmat({'Output'},numOut,1)];
            Name  = [parameterIn;parameterOut];
            
            if isempty(type) || isempty(description)
                % get type and description from help text
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
            end
                                
            if isa(obj,'latexGenerator')
                Name  = cellfun(@(x) ['{\tt ',x,'}'], Name, 'Uni',0);
            elseif isa(obj,'markdownGenerator')
                Name  = cellfun(@(x) ['°',x,'°'], Name, 'Uni',0);
            end
            Type  = reshape(type,[],1);
            if isa(obj,'latexGenerator')
                Type  = cellfun(@(x) ['{\tt ',x,'}'], Type, 'Uni',0);
            elseif isa(obj,'markdownGenerator')
                Type  = cellfun(@(x) ['°',x,'°'], Type, 'Uni',0);
            end
   
            Description = reshape(description,[],1);
            funcTable = table(InOut,Name,Type,Description);
            if isa(obj,'latexGenerator')
                obj.set('tableColumnAlignment','|l|l|l|p{8cm}|')
            end
            if ~isempty(pre), obj.addParagraph(pre); end
            obj.addListing(func)
            obj.addTabular(funcTable)
            obj.setDefault('tableColumnAlignment')
            if ~isempty(post), obj.addParagraph(post); end
            %obj.dispLatexCode([{['% Function']},{'%'},text])

        end    
        
               
        
        addTitlePage
        addHeading
        addList
        addListing
        
    end
    
end