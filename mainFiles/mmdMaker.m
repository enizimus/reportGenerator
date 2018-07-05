classdef mmdMaker < handle
    
    properties
        pre
        main
        post
        
        text = {}
    end
    
    properties (Access=protected)
        
        subFields = {'type','content','info'}
        
        headingMatch
        headingType = {'#','##','###'}
        headingCounter = 0
        headingAnchorLevelMax = 3
        headingAnchor = '<a name="#ANCHOR#"></a>'
        headingContent = struct() % 'text','','anchor','','level',[],'line',[]);
        
        anchorPre = {['1.'],[char(9),'-'],[char(9),char(9),'-']}
        
        
        listingMatch
        listingType = {['-'],[char(9),'-'],[char(9),char(9),'-']}
        
        enumerationMatch
        enumerationType = {['1.'],[char(9),'2.'],[char(9),char(9),'3.']}
        
        textMatch
        textType = {[''],[char(9)],[char(9),char(9)]}
        
        
        
        codeShift = [char(9),char(9),char(9)] %blanks(8)
        
        prettyCode  = 'mltutorShrinkOutput'
        showmatCode = 'showmata'
        showmatbwCode = 'showmatabw'
        
        mmdFile     = 'test.mmd'
        figFileNum  = 0
        figFilePre  = 'pict_'
        figFileTyp  = 'png'
        figFilePost = '.png'
        figDir      = 'MediaFiles'
        
        
        figureStyleText
        figureStyle =  containers.Map( ...
            { ...
            'display','border','margin','text-align', ...
            'padding' ...
            }, ...
            { ...
            'inline-block','1px solid gray','2px','center', ...
            '2px' ...
            }, ...
            'UniformValues',1);
                                
        imageStyleText
        imageStyle = containers.Map( ...
            {'align','width'}, ...
            {'middle','600'}, ...
            'UniformValues',1);
        
        centerEnvironment = { ...
            '<center>','#CENTER#','</center>' ...
            }
        figureEnvironment = ...
            { ...
            '<figure style="#STYLE#">', ...
            '#IMAGE#', ...
            '<figcaption>','#CAPTION#','</figcaption>', ...
            '</figure>'
            }
        imageEnvironment = { ...
            '<img src="#FILE#" alt="#ALT#" style="#STYLE#"/>' ...
            }
                
    end
    
    
    
    methods
        function obj = mmdMaker(main)
            
            if nargin < 1, main = {struct()}; end
            
            
            
            
            obj.main = main;
            
            obj.consolitate;
            
            obj.makeMatches;
            obj.makeStyles;
            
            
            
            obj.makeText;
            obj.makeContentListing;
            
            
            obj.writeText;
            obj.mmd2html;
        end
        
        
        function consolitate(obj)
            if ~iscell(obj.main), obj.main = {obj.main}; end
            for kobj = 1:numel(obj.main)
                % make sure exec is present an dproperly filled
                if ~isfield(obj.main{kobj},'exec'), obj.main{kobj}.('exec')={}; end
                if ~iscell(obj.main{kobj}.('exec')), obj.main{kobj}.('exec') = {obj.main{kobj}.('exec')}; end
                partNames = fieldnames(obj.main{kobj}).';
                L = strcmp(partNames,'exec');
                partNames = partNames(~L);
                if isempty(obj.main{kobj}.('exec')), obj.main{kobj}.('exec') = partNames; end
                
                for kp = 1:numel(partNames)
                    part = partNames{kp};
                    for km = 1:numel(obj.subFields)
                        sub = obj.subFields{km};
                        if ~isfield(obj.main{kobj}.(part),sub), obj.main{kobj}.(part).(sub) = {}; end
                        if ~iscell(obj.main{kobj}.(part).(sub)), obj.main{kobj}.(part).(sub) = {obj.main{kobj}.(part).(sub)}; end
                    end
                    sub = 'type';
                    if isempty(obj.main{kobj}.(part).(sub))
                        warning([sub,' in ','main{',num2str(kobj),'}.(',part,')', ...
                            ' is empty and is ignored!'])
                    end
                    
                end
            end
        end % consolitate
        
        function makeMatches(obj)
            % heading
            str = 'heading';
            obj.headingMatch = arrayfun(@(x) str(1:x),1:numel(str),'Uni',0);
            str = '###';
            obj.headingMatch = [obj.headingMatch, arrayfun(@(x) str(1:x),1:numel(str),'Uni',0)];
            str = 'listing';
            obj.listingMatch = arrayfun(@(x) str(1:x),1:numel(str),'Uni',0);
            str = 'enumeration';
            obj.enumerationMatch = arrayfun(@(x) str(1:x),1:numel(str),'Uni',0);
            str = 'text';
            obj.textMatch = arrayfun(@(x) str(1:x),1:numel(str),'Uni',0);
            
        end % makeMatches
        
        function makeStyles(obj)
            text = '';
            names = keys(obj.figureStyle);
            for k = 1:numel(names)
                name = names{k};
                text = [text,name,': ',obj.figureStyle(name),'; '];
            end
            obj.figureStyleText = text;
            
            text = '';
            names = keys(obj.imageStyle);
            for k = 1:numel(names)
                name = names{k};
                text = [text,name,': ',obj.imageStyle(name),'; '];
            end
            obj.imageStyleText = text;
        end % makeStyles
        
        function makeText(obj)
            for kobj = 1:numel(obj.main)
                partNames = obj.main{kobj}.('exec');
                for kp = 1:numel(partNames)
                    part = partNames{kp};
                    newText = {};
                    type    = obj.main{kobj}.(part).('type');
                    content = obj.main{kobj}.(part).('content');
                    info    = obj.main{kobj}.(part).('info');
                    for kt = 1:numel(type)
                        typRead = type{kt};
                        
                        typSplit = regexp(typRead,'(^[a-zA-Z]+)_*(\d*)','tokens');
                        typ = lower(typSplit{1}{1});
                        typNum  = str2num(typSplit{1}{2});
                        
                        
                        switch typ
                            case obj.headingMatch % heading
                                if isempty(typNum), typNum = 1; end
                                level = min(typNum,numel(obj.headingType));
                                if level < obj.headingAnchorLevelMax
                                    obj.headingCounter = obj.headingCounter + 1;
                                    anchor = strrep(content{1},blanks(1),'_');
                                    obj.headingContent(obj.headingCounter).('text')   = content{1};
                                    obj.headingContent(obj.headingCounter).('anchor') = anchor;
                                    obj.headingContent(obj.headingCounter).('level')  = level;
                                    obj.headingContent(obj.headingCounter).('line')   = numel(obj.text)+1;
                                    anchorText = strrep(obj.headingAnchor,'#ANCHOR#',anchor);
                                    newText = [newText,anchorText];
                                end
                                
                                pre = obj.headingType{level};
                                contentMod = [pre,blanks(1),content{1}];
                                newText = [newText,contentMod];
                                
                            case [obj.listingMatch,obj.enumerationMatch] % listing,enumeration
                                for kcont = 1:numel(content)
                                    if isempty(typNum) && isempty(info)
                                        typLocNum = 1;
                                    elseif ~isempty(info)
                                        typLocNum = info{min(kcont,numel(info))};
                                    else
                                        typLocNum = typNum;
                                    end
                                    switch typ
                                        case obj.listingMatch
                                            pre = obj.listingType{min(typLocNum,numel(obj.listingType))};
                                        case obj.enumerationMatch
                                            pre = obj.enumerationType{min(typLocNum,numel(obj.enumerationType))};
                                    end
                                    preText = obj.textType{min(typLocNum,numel(obj.textType))};
                                    
                                    if iscell(content{kcont})
                                        contentMod = content{kcont};
                                        contentMod{1} = [pre,blanks(1),contentMod{1},'<br>'];
                                        for kcm = 2:numel(contentMod)
                                            contentMod{kcm} = [preText,contentMod{kcm},'<br>'];
                                        end
                                    else
                                        contentMod = {[pre,blanks(1),content{kcont}],'<br>'};
                                    end
                                    newText = [newText,contentMod];
                                end
                                
                            case obj.textMatch % text
                                for kcont = 1:numel(content)
                                    if isempty(typNum) && isempty(info)
                                        typLocNum = 1;
                                    elseif ~isempty(info)
                                        typLocNum = info{min(kcont,numel(info))};
                                    else
                                        typLocNum = typNum;
                                    end
                                    pre = obj.textType{min(typLocNum,numel(obj.textType))};
                                    
                                    if iscell(content{kcont})
                                        contentMod = [ [pre,content{kcont}{1}],content{kcont}(2:end),{'<br>'}];
                                    else
                                        contentMod = {[pre,content{kcont}],{'<br>'}};
                                    end
                                    newText = [newText,contentMod];
                                end
                                
                            case 'table'
                                tableText = {};
                                maxCol = max(cellfun(@numel,content));
                                content = cellfun(@(x) [x,num2cell(blanks(maxCol-numel(x)))], content, 'Uni',0);
                                
                                for kc = 1:numel(content)
                                    lineText = ['| ',strjoin(content{kc},' | '),' |'];
                                    tableText = [tableText,lineText];
                                    if kc == 1
                                        lineText = ['|',strjoin(num2cell(repmat('-',1,maxCol)),'|'),'|'];
                                        tableText = [tableText,lineText];
                                    end
                                end
                                newText = [newText,tableText];
                                
                            case 'code'
                                contentMod = cellfun(@(x) [obj.codeShift,x], content, 'Uni',0);
                                newText = [newText,contentMod];
                            case 'exec'
                                for ke = 1:numel(content)
                                    eval([content{ke},';'])
                                end
                            case 'pretty'
                                for ke = 1:numel(content)
                                    str = {[content{ke},' = ']};
                                    str = cellfun(@(x) [obj.codeShift,x], str, 'Uni',0);
                                    newText = [newText,str,{''}];
                                    eval(['str = ',obj.prettyCode,'(',content{ke},');'])
                                    str = strsplit(str,char(10));
                                    str = cellfun(@(x) [obj.codeShift,x], str, 'Uni',0);
                                    newText = [newText,str,{''}];
                                end

                            case 'latex'
                                for ke = 1:numel(content)
                                    eval(['str = ',obj.prettyCode,'(',content{ke},',[],[],[],[],[],1);'])
                                    str = ['$$',content{ke},' = ',strrep(str,'$$',''),'$$'];
                                    str = strsplit(str,char(10));
                                    newText = [newText,str,{''}];
                                end
                                
                            case {'figure','showmat','showmatbw'}
                                
                                if ~exist(obj.figDir,'dir'), mkdir(obj.figDir); end
                                
                                switch typ
                                    case {'showmat','showmatbw'}
                                        switch typ
                                            case 'showmat'
                                                myCode = obj.showmatCode;
                                            case 'showmatbw'
                                                myCode = obj.showmatbwCode;
                                        end
                                        for kshow = 1:numel(content)
                                            cont = content{kshow};
                                            if ~iscell(cont), cont = {cont}; end
                                            eval('figure;')
                                            eval([myCode,'(',strjoin(cont,','),');'])
                                        end
                                end
                                
                                figureList = get(0,'Children');
                                
                                myImage = cell(1,numel(figureList));
                                cfig = 0;
                                for kfig = numel(figureList):-1:1
                                    cfig = cfig + 1;
                                    fig = figureList(kfig);
                                    obj.figFileNum = obj.figFileNum + 1;
                                    file = [obj.figDir,filesep,obj.figFilePre,num2str(obj.figFileNum),obj.figFilePost];
                                
                                    print(fig,['-d',obj.figFileTyp],file)
                                    
                                    myImage{cfig} = obj.imageEnvironment;
                                    myImage{cfig} = strrep(myImage{cfig},'#STYLE#',obj.imageStyleText);
                                    myImage{cfig} = strrep(myImage{cfig},'#FILE#',file);
                                    myImage{cfig} = strrep(myImage{cfig},'#ALT#',[obj.figFilePre,num2str(obj.figFileNum),obj.figFilePost]);
                                    myImage{cfig} = strjoin(myImage{cfig},char(10));
                                end
                                myImage = strjoin(myImage,char(10));
                                delete(figureList)
                                
                                
                                myFigure = obj.figureEnvironment;
                                myFigure = strrep(myFigure,'#STYLE#',obj.figureStyleText);
                                myFigure = strrep(myFigure,'#IMAGE#',myImage);
                                if ~isempty(info)
                                    myFigure = strrep(myFigure,'#CAPTION#',info{1});
                                else
                                    myFigure = strrep(myFigure,'#CAPTION#','');
                                end
                                myFigure = strjoin(myFigure,char(10));
                                
                                myText   = strrep(obj.centerEnvironment,'#CENTER#',myFigure);
                                myText = strjoin(myText,char(10));
                                newText = [newText,myText];
                            otherwise
                                warning([typ,' in ','main{',num2str(kobj),'}.(',part,')', ...
                                    ' does not exist and is ignored!'])
                                
                        end % end switch typ
                    end % end for typ
                    obj.text = [obj.text,newText,{''}];
                end % end for part
            end % end for main
        end % makeText
        
        function makeContentListing(obj)
            
            if ~isempty(obj.headingContent)
                headingContent = {};
                skipFirst = false;
                
                levels = [obj.headingContent(:).('level')];
                
                for k = 1:numel(obj.headingContent);
                    text = obj.headingContent(k).('text');
                    anchor = obj.headingContent(k).('anchor');
                    line = obj.headingContent(k).('line');
                    if k==1 && line == 1,
                        skipFirst = true;
                        levels = levels(2:end);
                        continue
                    end
                    level = obj.headingContent(k).('level') - min(levels) + 1;
                    anchorText = ['[',text,'](#',anchor,')'];
                    
                    anchorText = {[obj.anchorPre{level},blanks(1),anchorText]};
                    headingContent = [headingContent,anchorText];
                end
                
                if skipFirst
                    headingContent = [{''},headingContent];
                    obj.text = [obj.text(1:2),headingContent,obj.text(3:end)];
                else
                    headingContent = [headingContent,{''}];
                    obj.text = [headingContent,obj.text];
                end
                
            end
            
            
            
        end % makeContentListing
        
        
        function writeText(obj)
            [stat] = mltutorWriteFile(obj.text,obj.mmdFile)
        end % writeText
        
        function mmd2html(obj)
            mmd2html(obj.mmdFile)
        end % mmd2html
        
        
    end
    
end