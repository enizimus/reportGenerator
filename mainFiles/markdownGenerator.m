classdef markdownGenerator < reportGenerator
    
    properties (Access = protected)
        headingList = struct('chapter','#','section','##', ...
            'subsection','###','subsubsection','####')
        headingStore = struct();
    end
    
    methods
        
        function obj = markdownGenerator(varargin)
            p = inputParser;
            p.addParameter('settingFile',  'markdown.dat', @isstr)
            p.parse(varargin{:})
            obj.initSetting(p);
            obj.readTemplate;
            if ~isempty(obj.get('textBlockFile')), obj.readTextBlock; end
            if ~isempty(obj.get('codeBlockFile')), obj.readCodeBlock; end
            obj.runMatlabInit;
        end % markdownGenerator
        
        function cleanDir(obj)
            extList = {'aux','fls','db_latexmk','idx','ilg','ind','log','out'};
            for k = 1:numel(extList)
                ext = extList{k};
                delete(['*.',ext])
            end
            delete(obj.getFileName('report'))
        end % cleanDir
        
        function addTitlePage(obj)
            text = {['# ',obj.get('title')]};
            if ~isempty(obj.get('author'))
                text = [text,{obj.get('author')}];
            end
            obj.addText(text)
        end % addTitlePage
        
        function addTableOfContents(obj)
            obj.addText('+TABLEOFCONTENTS+')
        end % addTableOfContents
        
        function createTableOfContents(obj)
            text = {};
            for k = 1:numel(obj.headingStore)
                anchor = ['(#',obj.headingStore(k).anchor,')'];
                new =['[',obj.headingStore(k).text,']',anchor];
                switch obj.headingStore(k).level
                    case 1, pre = '1. ';
                    otherwise, pre = '- ';
                end
                new = obj.shiftText({[pre,new]},obj.headingStore(k).level-1);
                text = [text,new];
            end
            obj.addText(text,1,'TABLEOFCONTENTS')
        end % createTableOfContents(obj)
        
        function addHeading(obj,type,heading,label)
            type = strrep(type,'*','');
            if isfield(obj.headingList,type);
                type = obj.headingList.(type);
            end
            count = num2str(obj.increaseCounter(strrep(type,'#','HASH')));
            headingCount = obj.increaseCounter('heading');
            
            if nargin<4 || isempty(label), 
                label = [type,':',count]; % TODO heading abbr
            end
            pre = [type,blanks(1)];
            
            text = {['<a name="',label,'"></a>'], ...
                [pre,heading]};
            obj.addText(text)
            obj.headingStore(headingCount).anchor = label;
            obj.headingStore(headingCount).text   = heading;
            obj.headingStore(headingCount).level  = numel(type);
        end % addHeading
        
        function varargout = addList(obj,type,items)
            type  = obj.wrapOutCell(type);
            items = obj.wrapInCell(items);
            switch type
                case {'itemize','description'}
                    pre = '- ';
                case 'enumerate'
                    pre = '1. ';
            end
            
            
            if isempty(items), items = {''}; end
            text = {};
            for k = 1:numel(items)
                item = obj.wrapInCell(items{k});
                if regexp(item{1},'\s*(-|1\.)')
                    subList = true;
                else
                    subList = false;
                end
                
                switch type
                    case 'description'
                        if subList
                            subListCount = obj.increaseCounter('subList');
                            text = [text,obj.shiftText(obj.addParagraph(item),subListCount)];
                        else
                            new = {['**',item{1},'**']};
                            new = obj.shiftText([new,obj.addParagraph(item(2:end))],1);
                            new{1} = [pre,new{1}(numel(pre)+1:end)];
                            new = cellfun(@(x) [x,'<br>'],new,'Uni',0);
                            text = [text,new];
                        end
                    otherwise
                        if subList
                            subListCount = obj.increaseCounter('subList');
                            text = [text,obj.shiftText(obj.addParagraph(item),subListCount)];                            
                        else
                            new = obj.shiftText(obj.addParagraph(item),1);
                            new{1} = [pre,new{1}(numel(pre)+1:end)];
                            new = cellfun(@(x) [x,'<br>'],new,'Uni',0);
                            text = [text,new];
                        end
                end
            end
            if subList, subListCount = obj.decreaseCounter('subList'); end
            if nargout > 0
                varargout{1} = text;
            else    
                text = [text,{[' ']}];
                obj.addText(text)
            end
        end %addList
        
        function addListing(obj,code,shiftAmount,startLine,endLine)
            if nargin < 3 || isempty(shiftAmount), shiftAmount = 1; end
            code = obj.wrapInCell(code);
            if nargin < 4 || isempty(startLine), startLine = 1; end
            if nargin < 5 || isempty(endLine), endLine = numel(code); end
            code = code(startLine:endLine);
            code = obj.shiftText(code,shiftAmount);
            obj.addText(code)
            obj.dispLatexCode([{['% Listing']},{'%'},code])
        end %addListing
        
        function varargout = addImage(obj,images)

            imagePerLine = obj.get('imagePerLine',2,@str2num);
            imageOption  = obj.get('imageOption');
            
            figNames = obj.getFigureNames(images);
            
            imageTemplate = ['<img src="#FILE#" alt="#FILE#" style="',imageOption,' "/>'];

            
            if nargout==0, text = {'<center>'}; else, text = {}; end
            for kf = 1:numel(figNames)
                figName = figNames{kf};
                myImage = strrep(imageTemplate,'#FILE#',figName);
                text = [text,{myImage}];
                if mod(kf-1,imagePerLine)+1 == imagePerLine && kf ~= numel(figNames)
                    text = [text,{'<br>'}];
                end
            end
            if nargout==0, text = [text,{'</center>'}]; end
            if nargout == 0
                obj.addText(text);
            else
                varargout{1} = text;
            end
            obj.dispLatexCode([{['% Image']},{'%'},text])
        end % addImage
        
        function varargout = addFigure(obj,figHandles,caption,label)
            figureOption  = obj.get('figureOption');
            count = num2str(obj.increaseCounter('figure'));
            if nargin<4 || isempty(label), 
                label = ['fig:',count];
            end
            %figurePlacement = obj.get('figurePlacement');
            % no latex output from image when called by figure
            storeDisp = obj.get('dispLatexCode');
            obj.set('dispLatexCode',0);
            imageText = obj.addImage(figHandles);
            obj.set('dispLatexCode',storeDisp);
                        
            text = [{['<center>']}, ...
                {['<figure style="',obj.get('figureOption'),' ">']}, ...
                imageText];
            if ~isempty(caption)
                text = [text,{'<figcaption>',caption,'</figcaption>'}];
            end
            % text = [text,{['\label{',label,'}']}];
            text = [text,{['</center>']}];
            obj.addText(text);
            if nargout>0, varargout{1} = text; end
            obj.dispLatexCode([{['% Figure with label: ',label]},{'%'},text])
        end % addFigure
        
        function varargout = addTabular(obj,data)
%             input = struct();
%             input.tablePlacement       = obj.get('tablePlacement','ht'); 
%             input.transposeTable       = obj.get('transposeTable',0,@str2num); 
%             input.dataFormatMode       = obj.get('dataFormatMode','column'); 
%             input.dataFormat           = obj.get('dataFormat','%.4f'); 
%             input.dataNanString        = obj.get('dataNanString','-'); 
%             input.tableColumnAlignment = obj.get('tableColumnAlignment','c'); 
%             input.tableBorders         = obj.get('tableBorders',1,@str2num); 
%             input.booktabs             = obj.get('booktabs',0,@str2num); 
%             input.centerTabular        = obj.get('centerTabular',1,@str2num); 

            % 
            
            colLabels = strsplit(obj.get('tableColLabels'),',');
            rowLabels = strsplit(obj.get('tableRowLabels'),',');
            dataFormat = strsplit(obj.get('dataFormat','%.4f'),','); 
            transposeTable = obj.get('transposeTable',0,@str2num);
            dataNanString = obj.get('dataNanString','-');            
            centerTabular = obj.get('centerTabular',1,@str2num);
            
            if isnumeric(data)
                data = num2cell(data);
            elseif istable(data)
                rowLabels = data.Properties.RowNames;
                colLabels = data.Properties.VariableNames;
                data = table2cell(data);
            end
            
            if numel(dataFormat) == 1
                dataFormat = repmat(dataFormat,1,size(data,2));
            end
            
            for kc = 1:size(data,2)
                for kr = 1:size(data,1)
                    if ~ischar(data{kr,kc})
                        if isnan(data{kr,kc})
                            data{kr,kc} = dataNanString;
                        else
                            data{kr,kc} = sprintf(dataFormat{kc},data{kr,kc});
                        end
                    end
                end
            end
            sizeData = size(data);
            
            hasHeader = false;
            if numel(colLabels) == sizeData(2)
                hasHeader = true;
                colLabels = cellfun(@(x) ['**',x,'**'], colLabels, 'Uni',0);
                data = [reshape(colLabels,1,[]);data];
            end
            
            if numel(rowLabels) == sizeData(1)
                rowLabels = cellfun(@(x) ['**',x,'**'], rowLabels, 'Uni',0);
                if numel(rowLabels) == size(data,1)
                    data = [reshape(rowLabels,[],1),data];
                else
                    data = [[{''};reshape(rowLabels,[],1)],data];
                end
            end
            
            if transposeTable, data = data.'; end
            
            text = {};
            for kr = 1:size(data,1)
                if kr == 1 && ~hasHeader
                    row = [repmat('|-',1,size(data,2)),'|'];
                    text = [text,{row}];
                end
                row = ['| ',strjoin(data(kr,:),' | '),' |'];
                text = [text,{row}];
                if kr == 1 && hasHeader
                    row = [repmat('|-',1,size(data,2)),'|'];
                    text = [text,{row}];
                end
            end
            
            % if centerTabular, text = [{'<center>'},text,{'</center>'}]; end
            % text = [{'<table style="width:100%">'},text,{'</table>'}];
            
            
            if nargout == 0
                obj.addText([text,{'<br>'}])
            else
                varargout{1} = text;
            end
            obj.dispLatexCode([{['% Tabular: ']},{'%'},text])
        end % addTabular

        function varargout = addTable(obj,data,caption,label)
            count = num2str(obj.increaseCounter('table'));
            if nargin<4 || isempty(label), 
                label = ['tab:',count];
            end
            if ~isempty(caption)
                text = [{'<center>'},{['<b>Table ',count,':</b> ',caption]},{'</center>'}];
                obj.addText(text);
            end
            obj.addTabular(data)
         end % addTable
    end
    
end