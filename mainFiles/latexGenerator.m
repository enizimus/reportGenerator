classdef latexGenerator < reportGenerator
    
    methods
        
        function obj = latexGenerator(varargin)
            % latexGenerator ... constructor function 
            %
            % params : 'settingFile', 'settingFileName.dat'
            %           Key-Value pair for choosing a settings file
            % return : ~
            
            p = inputParser;
            p.addParameter('settingFile',  'setting.dat', @isstr)
            p.parse(varargin{:})
            obj.initSetting(p);
            obj.readTemplate;
            if ~isempty(obj.get('textBlockFile')), obj.readTextBlock; end
            if ~isempty(obj.get('codeBlockFile')), obj.readCodeBlock; end
            obj.runMatlabInit;
        end % latexGenerator
        
        function cleanDir(obj)
            % cleanDir 
            %
            % cleans the working directory from old files
            extList = {'aux','fls','db_latexmk','idx','ilg','ind','log','out'};
            for k = 1:numel(extList)
                ext = extList{k};
                delete(['*.',ext])
            end
            delete(obj.getFileName('report'))
        end % cleanDir
        
        function cleanUp(obj)
            % cleanUp
            %
            % cleans the working directory from all files except the .pdf
            
            extList = {'aux','fls','db_latexmk','idx','ilg','ind','log',...
                        'out','gz','fdb_latexmk','tex','toc'};
            for k = 1:numel(extList)
                ext = extList{k};
                delete(['*.',ext])
            end
        end % cleanDir
        
        function addNewPage(obj)
            % addNewPage(obj)
            %
            % Ends the current page and starts on a new one, it will
            % also force the placement of figure functions that were 
            % execute beforehand.
            %
            obj.addParagraph('\newpage');
        end
        
        function addTitlePage(obj)
            % addTitlePage 
            %
            % Adds a title page for your document, with the 
            % title, author and date from your setting file.
            replaceList = {'author','title','date'};
            for k = 1:numel(replaceList)
                rep = replaceList{k};
                obj.replaceKeyWord(upper(rep),obj.get(rep))
            end
            obj.addText('\maketitle')
        end % addTitlePage
        
        function addTableOfContents(obj)
            % addTableOfContents
            %
            % Adds a table of contents to your document.
            obj.addText('\tableofcontents')
        end % addTableOfContents
        
        function addHeading(obj,type,heading,label)
            % addHeading(obj, type, heading, label)
            %
            % Adds a heading to your document, with:
            %
            %  type : 'part'
            %         'chapter'
            %         'section'
            %         'subsection'
            %         'subsubsection'
            %
            %  heading : 'text in your heading type'
            %
            %  label : label for referencing your heading
            %
                      
            count = num2str(obj.increaseCounter(strrep(type,'*','_ast')));
            if nargin<4 || isempty(label) 
                label = [type,':',count]; % TODO heading abbr
            end
            text = {['\',type,'{',heading,'}'], ...
                ['\label{',label,'}'] ...
                };
            obj.addText(text)
        end % addHeading
        
        function varargout = addList(obj,type,items)
            % addList(obj, type, items)
            %
            % Adds a list to your document, with:
            %
            %  type : 'itemize'
            %         'enumerate'
            %
            %  items : array containing the items that are to be added
            %
            
            type  = obj.wrapOutCell(type);
            items = obj.wrapInCell(items);
            if isempty(items), items = {''}; end
            text = {['\begin{',type,'}']};
            for k = 1:numel(items)
                item = obj.wrapInCell(items{k});
                if regexp(item{1},'\\begin\s*\{(itemize|description|enumerate)\}')
                    subList = true;
                else
                    subList = false;
                end
                
                switch type
                    case 'description'
                        if subList
                            text = [text,obj.addParagraph(item)];
                        else
                            text = [text,{'\item[',item{1},']'}];
                            text = [text,obj.addParagraph(item(2:end))];
                        end
                    otherwise
                        if subList
                            text = [text,obj.addParagraph(item)];                            
                        else
                            text = [text,{'\item'},obj.addParagraph(item)];
                        end
                end
            end
            text = [text,{['\end{',type,'}']}];
            
            if nargout > 0
                varargout{1} = text;
            else    
                obj.addText(text)
            end
        end %addList
        
        function addListing(obj,code,shiftAmount,startLine,endLine)
            % addListing(obj, code, shiftAmount, startLine, endLine)
            %
            % Helper function for the addMatlab(...) function.
            %
            
            if nargin < 3 || isempty(shiftAmount), shiftAmount = 1; end
            code  = obj.wrapInCell(code);
            if nargin < 4 || isempty(startLine), startLine = 1; end
            if nargin < 5 || isempty(endLine), endLine = numel(code); end
            listingBasicStyle = obj.get('listingBasicStyle');
            code = code(startLine:endLine);
            code = obj.shiftText(code,shiftAmount);

            text = [{'\begin{minipage}[t]{\textwidth}'}];
            if isempty(listingBasicStyle)
                text = [text,{'\begin{lstlisting}'},code,{'\end{lstlisting}'}];
            else
                text = [text,{['\begin{lstlisting}[',listingBasicStyle,']']},code,{'\end{lstlisting}'}];
            end
            text = [text,{'\end{minipage}'}];
            obj.addText(text)
            obj.dispLatexCode([{['% Listing']},{'%'},text])
        end %addListing
        
        function varargout = addImage(obj,images)

            % gets how many pictures per line are set up
            imagePerLine = obj.get('imagePerLine',2,@str2num);
            % gets the image options
            imageOption  = obj.get('imageOption');
            
            %
            figNames = obj.getFigureNames(images);
            
            text = {'{','\hfill'};
            for kf = 1:numel(figNames)
                figName = figNames{kf};
                text = [text, ...
                    {['\includegraphics[',imageOption,']{',figName,'}']}, ...
                    {'\hfill'}];
                if mod(kf-1,imagePerLine)+1 == imagePerLine && kf ~= numel(figNames)
                    text = [text,{'}','','{','\hfill'}];
                end
            end
            text = [text,{'}'}];
            if nargout == 0
                obj.addText(text);
            else
                varargout{1} = text;
            end
            obj.dispLatexCode([{['% Image']},{'%'},text])
        end % addImage
        
        function varargout = addFigure(obj,figHandles,caption,label)
            % addFigure(obj, figHandles, caption, label)
            % 
            % Adds the figures that were passed through the figure handles
            % with the caption and label associated with them.
            %
        
            figPerLine = str2num(obj.get('imagePerLine'));
            count = num2str(obj.increaseCounter('figure'));
            if nargin<4 || isempty(label), 
                label = ['fig:',count];
            end
            figurePlacement = obj.get('figurePlacement');
            % no latex output from image when called by figure
            storeDisp = obj.get('dispLatexCode');
            obj.set('dispLatexCode',0);
            imageText = obj.addImage(figHandles);
            obj.set('dispLatexCode',storeDisp);
            nfigs = numel(figHandles);
            
            
            if nfigs > 1 && figPerLine == 1
                caption = obj.wrapInCell(caption);
                caption = obj.repeatString(caption, nfigs);
                
                for i = 1:nfigs
                    cap = obj.wrapOutCell(caption(i));
                    obj.addFigure(figHandles(i),cap);
                end
            else
                text = [{['\begin{figure}[',figurePlacement,']']}, ...
                    imageText];
                if ~isempty(caption)
                    text = [text,{['\caption{',caption,'}']}];
                end
                text = [text,{['\label{',label,'}']}];
                text = [text,{['\end{figure}']}];
                obj.addText(text);
                if nargout>0, varargout{1} = text; end
                obj.dispLatexCode([{['% Figure with label: ',label]},{'%'},text])
            end
        end % addFigure
        
        function varargout = addTabular(obj,myTable)
            % adds a table to the output, all settings are done through
            % calls to obj.set. Have a look at settings to see what is
            % possible.
            input = struct();
            input.tablePlacement       = obj.get('tablePlacement','ht'); 
            input.transposeTable       = obj.get('transposeTable',0,@str2num); 
            input.dataFormatMode       = obj.get('dataFormatMode','column'); 
            input.dataFormat           = obj.get('dataFormat','%.4f'); 
            input.dataNanString        = obj.get('dataNanString','-'); 
            input.tableColumnAlignment = obj.get('tableColumnAlignment','c'); 
            input.tableBorders         = obj.get('tableBorders',1,@str2num); 
            input.booktabs             = obj.get('booktabs',0,@str2num); 
            input.centerTabular        = obj.get('centerTabular',1,@str2num); 

            % fix dataFormat for use in latexTable
            tmp = strsplit(input.dataFormat,',');
            if any(cellfun(@(x) ~isempty(str2num(x)),tmp))
                for k=2:2:numel(tmp), tmp{k} = str2num(tmp{k}); end
            end
            input.dataFormat = tmp; 
            % 
            colLabels = obj.get('tableColLabels','');
            if ~isempty(colLabels), input.tableColLabels = strsplit(colLabels,','); end
            rowLabels = obj.get('tableRowLabels','');
            if ~isempty(rowLabels), input.tableRowLabels = strsplit(rowLabels,','); end
            
            
            input.data = myTable;
            input.addTable = 0;
            text = latexTable(input).';
            if nargout == 0
                obj.addText(text)
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
            tablePlacement = obj.get('tablePlacement');
            storeDisp = obj.get('dispLatexCode');
            obj.set('dispLatexCode',0);            
            tabularText = obj.addTabular(data);
            obj.set('dispLatexCode',storeDisp);
       
            text = [{['\begin{table}[',tablePlacement,']']}, ...
                tabularText];
            if ~isempty(caption)
                text = [text,{['\caption{',caption,'}']}];
            end
            text = [text,{['\label{',label,'}']}];
            text = [text,{['\end{table}']}];
            obj.addText(text);
            if nargout>0, varargout{1} = text; end
            obj.dispLatexCode([{['% Table with label: ',label]},{'%'},text])
         end % addTable
         
         function addEquation(obj, eqn, option)
        % addEquation(obj, eqn)
        %
        % param : 
        %       eqn : string containing equation written in latex code
        %       option : ' ' (empty parameter means standard one line equation) 
        %                'enumerate' (one line equation enumerated)
        %                'align' (equations will be aligned at '&' sign)
        %
        cbeg = '\begin{TEXT}';
        cend = '\end{TEXT}';
        eqnSep = obj.get('equationNewLine');
        if(nargin < 3 || isempty(option)), option = 'equation*'; end
        
        eqn = obj.wrapInCell(eqn);
        
        cbeg = strrep(cbeg, 'TEXT', option);
        cend = strrep(cend, 'TEXT', option);
        obj.packageEquation(eqn, cbeg, cend, eqnSep);
         end
         
         function packageEquation(obj, eqn, cbeg, cend, eqnSep)
             % packageEquation(obj, eqn, cbeg, cend, eqnSep)
             %
             % Helper function for the addEquation(...) function 
             %
             text = cbeg;
             for i=1:numel(eqn)
                 text = [text, eqn(i), eqnSep];
             end
             text = [text, cend];
             obj.addParagraph(text);
         end
       
         function zipFiles(obj, nameout)
             % zipFiles(obj, dir, file)
             % 
             % Makes a zip file of the directory you choose and puts it
             % into your current working directory
             
             if(nargin < 2 || isempty(nameout))
                 nameout
             
             wkd = pwd;
             copyfile('additionalFiles', [wkd,'\myReport\additionalFiles']);
             copyfile('*.m', [wkd, '\myReport']);
             copyfile('*.pdf', [wkd, '\myReport']);
             zip('myReportZip','myReport');
             rmdir 'myReport' s
         
         end
    
    end
    
end