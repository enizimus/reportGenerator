function [s,info] = mltutorShrinkOutput(M_in,com_max,max_size,max_show,max_show_fac,min_s,mklatex)
%
% Returns output of all kinds of arrays in a compressed form in the
% string s
%
% works with single,double,logical,all integer types
% works for real and complex numbers
% 
% Standard call:
% 
%   s = mltutorShrinkOutput(M_in);
%
% Specify maximum number of decimal places (optional)
%
%   s = mltutorShrinkOutput(M_in,com_max)
%
%   with
%
%   0 <= com_max <= 15 : maximum number of decimal places
%   'bank' ; 'b'        -> com_max = 2
%   'short'; 's'        -> com_max = 4 (default)
%   'intermediate'; 'i' -> com_max = 8
%   'long', 'l'         -> com_max = 15
%
% Further input (optional):
% 
%   max_size = [n_rows,n_cols] size of matrix printed, default [nan,nan]
% 
%   max_size = [nan,nan]
%   max_show = (rough) number of matrix elements printed (default 300)
%
%   max_show_fac = number of pages for higher dimensional arrays (default 3)
%
%   min_s = minimum number of columns (default 3)
%
%   mklatex = logical; make latex output (default false)
%
% Winfried Kernbichler 2010-01-14

% if ~isnumeric(M_in) || islogical(M_in)
%     error('only for numeric data types'); 
% end
if ~isnumeric(M_in) && ~islogical(M_in) % || islogical(M_in)
    s = M_in;
    info = [];
    return
else
    fo = '%.3g';
    class_str = ['(',class(M_in),')'];
    % size_str = strrep(mat2str(size(M_in)),' ',',');
    siz_M = size(M_in);
    form_M = ['[',repmat('%i,',1,numel(siz_M))]; form_M(end)=']';
    size_str = sprintf(form_M,siz_M);
    if any(strcmp(class(M_in),{'single','double'}))
        %info_str = ['<', ...
        %    num2str(min(M_in(:)),fo),',', ...
        %    num2str(mean(M_in(:)),fo),',' ...
        %    num2str(max(M_in(:)),fo), ...
        %    '>'];
        info_str = ['<', ...
            sprintf(fo,min(M_in(:))),',', ...
            sprintf(fo,mean(M_in(:))),',' ...
            sprintf(fo,max(M_in(:))), ...
            '>'];
    elseif islogical(M_in)
        info_str = '';
    else
        %info_str = ['<', ...
        %    num2str(min(M_in(:)),fo),',', ...
        %    num2str(max(M_in(:)),fo), ...
        %    '>'];
        info_str = ['<', ...
            sprintf(fo,min(M_in(:))),',', ...
            sprintf(fo,max(M_in(:))), ...
            '>'];
    end
    info = [class_str,size_str,info_str];
    if islogical(M_in), M_in = uint8(M_in); end
end

if nargin < 2 || isempty(com_max), com_max = ''; end
if isempty(com_max), com_max = 4; end
exp_disp = true;
if ischar(com_max)
    switch lower(com_max(1))
        case 's'
            com_max = 4;
        case 'b'
            com_max = 2;
            exp_disp = false;
        case 'i'
            com_max = 8;
        case 'l'
            com_max = 15;
        otherwise
            com_max = 4;
    end
end
com_max = fix( min( max(com_max,0), 15) );

if nargin < 3 || isempty(max_size), max_size = [nan,nan]; end
max_size = fix(max_size);
if numel(max_size)==1, max_size = [max_size,max_size]; end
if ~isnan(max_size(1)); max_size(1) = max(2,max_size(1)); end
if ~isnan(max_size(2)); max_size(2) = max(2,max_size(2)); end

if nargin < 4 || isempty(max_show), max_show = 400; end
if all(~isnan(max_size)), max_show = prod(max_size); end
max_show = fix( max(max_show,1) );

if nargin < 5 || isempty(max_show_fac), max_show_fac = 3; end
max_show_fac = fix( max(max_show_fac, 2) );

if nargin < 6 || isempty(min_s), min_s = 4; end
min_s = fix( max(min_s, 2) );

if nargin < 7 || isempty(mklatex), mklatex = false; end
%if ~islogical(mklatex), mklatex = logical(mklatex); end


if ~issparse(M_in)

    end_1 = 1;
    end_2 = 1;
    siz = size(M_in);
    
    max_show_pages = ceil(max_show*max_show_fac / min(max_show,prod(siz(1:2))));
    
    
    num_pages = 1;
    n_dim = ndims(M_in);
    if n_dim > 2
        num_pages = prod(siz(3:end));
    end
    if num_pages <= max_show_pages
        n_pages = 1:num_pages;
        all_pages = true;
    else
        n_pages = [1:max_show_pages-1,num_pages];
        all_pages = false;
    end
    
    s = '';
    
    for k_page = n_pages
        
        if k_page > 1; s = [s,sprintf('\n')]; end
        if k_page == num_pages && ~all_pages &~mklatex
            s = [s,' |',sprintf('\n')];
            s = [s,'\|/',sprintf('\n')];
            s = [s,'',sprintf('\n')];
        end
        if numel(n_pages) > 1
            if mklatex
                page_str = ['$[:,:'];
            else
                page_str = ['Page: [:,:'];
            end
            for k_dim = 3:n_dim
                k_s = siz(k_dim);
                k_pos = k_page;
                if k_dim == 3; div = 1; else, div = div*siz(k_dim-1); end
                k_ind = mod(ceil(k_pos/div)-1,k_s) + 1;
                %page_str = [page_str,',',num2str(k_ind)];
                page_str = [page_str,',',sprintf('%i',k_ind)];
                
            end
            if mklatex
                page_str = [page_str,']$',sprintf('\n'),sprintf('\n')];
            else
                page_str = [page_str,']',sprintf('\n'),sprintf('\n')];
            end
            if mklatex == 1
                s = [s,page_str];
                s = [s,'$$',sprintf('\n'),'\begin{bmatrix*}[r]',sprintf('\n')];
            elseif mklatex == 2
                s = [s,page_str];
                s = [s,'$$',sprintf('\n'),'\begin{bmatrix}',sprintf('\n')];
            else
                s = [s,page_str];
            end
        else
            if mklatex == 1
                s = ['$$',sprintf('\n'),'\begin{bmatrix*}[r]',sprintf('\n')];
            elseif mklatex == 2
                s = ['$$',sprintf('\n'),'\begin{bmatrix}',sprintf('\n')];
            end
        end
        
        M = M_in(:,:,k_page);
        
        [s1,s2] = size(M);
        
        if numel(M) > max_show
            if all(isnan(max_size))
                max_1 = min( ceil( sqrt(s1/s2*max_show) ) , s1 );
                if s1 <= min_s; max_1 = max(s1,max_1); end
                if max_1 < s1 & max_1 < min_s, max_1 = min_s; end
                
                max_2 = min( ceil( sqrt(s2/s1*max_show) ) , s2 );
                if s2 <= min_s; max_2 = max(s2,max_2); end
                if max_2 < s2 & max_2 < min_s, max_2 = min_s; end
                
                if max_1 <= max_2;
                    max_2 = ceil(max_show/max_1);
                else
                    max_1 = ceil(max_show/max_2);
                end
                
                if max_1 < s1 & max_1 < min_s, max_1 = min_s; end
                if max_2 < s2 & max_2 < min_s, max_2 = min_s; end
            elseif all(~isnan(max_size))
                max_1 = min(s1,max_size(1));
                max_2 = min(s2,max_size(2));
            elseif ~isnan(max_size(1))
                max_1 = min(s1,max_size(1));
                max_2 = min( ceil(max_show/max_1), s2);
                if s2 <= min_s; max_2 = max(s2,max_2); end
                if max_2 < s2 & max_2 < min_s, max_2 = min_s; end
                max_1,max_2
            elseif ~isnan(max_size(2))
                max_2 = min(s2,max_size(2));
                max_1 = min( ceil(max_show/max_2), s1);
                if s1 <= min_s; max_1 = max(s1,max_1); end
                if max_1 < s1 & max_1 < min_s, max_1 = min_s; end
            end
        else
            max_1 = s1;
            max_2 = s2;
        end
        
        if s1 > max_1
            i1_split = max_1-end_1+1;
            i1 = [1:i1_split,s1-end_1+1:s1];
        else
            i1_split = [];
            i1 = [1:s1];
        end
        if s2 > max_2
            i2_split = max_2-end_2+1;
            i2 = [1:i2_split,s2-end_2+1:s2];
        else
            i2_split = [];
            i2 = [1:s2];
        end
        M = M(i1,i2);
        M(i1_split,:) = nan;
        M(:,i2_split) = nan;
        
        [s1,s2] = size(M);
        Cr = create_cell(M,'r');
        if any(imag(M(:))~=0)
            Ci = create_cell(M,'i');
            C = cell(size(Cr));
            for k1 = 1:s1
                for k2 = 1:s2
                    if k2 == i2_split
                        C{k1,k2} = Cr{k1,k2};
                    elseif k1 == i1_split
                        C{k1,k2} = [Cr{k1,k2},repmat(' ',1,numel(Ci{k1,k2})+3)];
                    else
                        ci = Ci{k1,k2};
                        ind = regexp(ci,'[+-]');
                        ind = ind(1);
                        sig = ci(ind);
                        ci(ind) = [];
                        C{k1,k2} = [Cr{k1,k2},' ',sig,ci];
                    end
                    if mklatex
                        if k2 == s2
                            C{k1,k2} = [C{k1,k2},' \\'];
                        else
                            C{k1,k2} = [C{k1,k2},' & '];
                        end
                    end
                end
            end
        else
            C = Cr;
            if mklatex
                for k1 = 1:s1
                    for k2 = 1:s2
                        if k2 == s2
                            C{k1,k2} = [C{k1,k2},' \\'];
                        else
                            C{k1,k2} = [C{k1,k2},' & '];
                        end
                    end
                end
            end
        end
        
        s_add = '';
        for k1 = 1:size(C,1)
            if ~mklatex & k1 == i1_split, s_add = [s_add,sprintf('\n')]; end
            s_add = [s_add,cell2mat(C(k1,:)),sprintf('\n')];
            if ~mklatex & k1 == i1_split, s_add = [s_add,sprintf('\n')]; end
        end
        
        if isempty(s_add)
            if mklatex
                s = ['\\',sprintf('\n')];
            else
                s = ['[]',sprintf('\n')];
            end
        else
            s = [s,s_add];
        end
        if mklatex == 1
            s = [s,'\end{bmatrix*}',sprintf('\n'),'$$',sprintf('\n')];
        elseif mklatex == 2
            s = [s,'\end{bmatrix}',sprintf('\n'),'$$',sprintf('\n')];
        end
    end % pages
    
    if mklatex
        %s = strrep(s,'NaN','\ast');
        s = strrep(s,'NaN','\mathrm{NaN}');
        s = strrep(s,'nan','\mathrm{NaN}');
        s = strrep(s,'Inf','\infty');
        %s = strrep(s,'\begin{bmatrix}',['\left[ \begin{array}{',repmat('c',1,size(C,2)),'}']);
        %s = strrep(s,'\end{bmatrix}','\end{array} \right]');
    else
        if isempty(s), s = ['[]',sprintf('\n')]; end
    end
else
    % works but it is not optimized
    max_sparse_length = 10;
    s = '';
    [si,sj,sv] = find(M_in); rp = real(sv); ip = imag(sv);
    if any(imag(sv(:))), is_complex = true; else is_complex = false; end
    if all(rp == fix(rp))
        form_r = '%i';
    else
        form_r = '%.6g';
    end
    if all(ip == fix(ip))
        form_i = '%-i';
    else
        form_i = '%-.6g';
    end
    for k = 1:numel(si)
        if k <= max_sparse_length - 2 || k == numel(si)
            %s = [s,'(',num2str(si(k)),',',num2str(sj(k)),')'];
            %s = [s,' ',num2str(rp(k),form_r)];
            s = [s,'(',sprintf('%i',si(k)),',',sprintf('%i',sj(k)),')'];
            s = [s,' ',sprintf(form_r,rp(k))];
            if is_complex
                if ip(k) >= 0
                    ip_sign = '+';
                else
                    ip_sign = '-';
                end
                %s = [s,' ',ip_sign,' ',num2str(abs(ip(k)),form_i),' i'];
                s = [s,' ',ip_sign,' ',sprintf(form_i,abs(ip(k))),' i'];
            end
            s = [s,sprintf('\n')];
        elseif k == numel(si)-1
            s = [s,sprintf(' |\n')];
        end
    end
end

    function C = create_cell(M,type)
        
        if strcmp(type,'r')
            %C = mat2cell(real(M),ones(1,s1),ones(1,s2));
            C = num2cell(real(M));
        else
            %C = mat2cell(imag(M),ones(1,s1),ones(1,s2));
            C = num2cell(imag(M));
        end
        M(i1_split,:) = [];
        
        if ~isempty(i1_split)
            if mklatex
                [C{i1_split,:}] = deal('\vdots');
            else
                [C{i1_split,:}] = deal('|');
            end
        end
        if ~isempty(i2_split)
            if mklatex
                [C{:,i2_split}] = deal(' \cdots ');
            else
                [C{:,i2_split}] = deal('  > ');
            end
        end
        if ~isempty(i1_split) & ~isempty(i2_split)
            if mklatex
                [C{i1_split,i2_split}] = ' \ddots ';
            else
                [C{i1_split,i2_split}] = '  > ';
            end
        end
        
        i1 = setdiff(1:s1,i1_split);
        i2 = setdiff(1:s2,i2_split);
        
        
        max_abs_vec = zeros(1,numel(i2));
        min_abs_vec = zeros(1,numel(i2));
        k2_count = 0;
        for k2 = i2
            k2_count = k2_count + 1;
            if strcmp(type,'r')
                N = real(double(M(:,k2)));
            else  
                N = imag(double(M(:,k2)));
            end
            N = N(~isnan(N)&~isinf(N));
            max_abs_hlp = max(abs(N));
            if isempty(max_abs_hlp), max_abs_hlp = 1; end
            max_abs_vec(k2_count) = max_abs_hlp;
            min_abs_hlp = min(abs(N(N~=0)));
            if isempty(min_abs_hlp), min_abs_hlp = 1; end
            min_abs_vec(k2_count) = min_abs_hlp;
        end
        
       
        k2_count = 0;
        for k2 = i2
            k2_count = k2_count + 1;
            if strcmp(type,'r')
                N = real(double(M(:,k2)));
            else  
                N = imag(double(M(:,k2)));
            end
            num_nan = double(any(isnan(N)) | any(isinf(N)))*4;
            
            N_sig = N(~isnan(N));
            N = N(~isnan(N)&~isinf(N));
            
            int = isinteger(N) || all(N==fix(N));
            num_dig = max(0,floor(log10(max(abs(N)))))+1;
            num_sig = double(any(N_sig<0));
            
            num_com = 0;
            if ~int
                for num_com = 1:com_max
                    N_shift = N*10^num_com;
                    if all(N_shift==fix(N_shift)), break; end
                end
            end
            
            max_abs = max_abs_vec(k2_count);
            min_abs = min_abs_vec(k2_count);
            
            num_exp = [];
            if strcmp(type,'r')
                form_pre = '%';
                form_aft = '';
            else
                form_pre = '%+';
                num_sig = 1;
                if mklatex
                    form_aft = '\\rm{i}';
                else
                    form_aft = 'i'; %'*i';
               end
            end
            % if max_abs >= 1.e6 | min_abs <= 1.e-6
            %if max_abs >= 10^com_max | min_abs <= 10^(-com_max)
            %if max_abs >= 10^6 | min_abs <= 10^(-com_max)
            if exp_disp && (any(max_abs_vec >= 10^6) || any(min_abs_vec <= 10^(-max(1,min(com_max,6)))))
                num_exp = 4;
                if max(0,floor(log10( max(max_abs,1/min_abs))))+1 >= 100; num_exp = num_exp+1; end
                num_pre = max(1 + num_com + num_sig + 1 + double(~int) + num_exp,num_nan);
                
                T = N.*10.^(-floor(log10(abs(N))));
                T = T(~isnan(T));
                for num_com_mod = 1:com_max
                    T_shift = T*10^num_com_mod;
                    if all(T_shift==fix(T_shift)), break; end
                end
                if isempty(num_com_mod), 
                    num_com_mod = 0; 
                    num_add = 2;
                else
                    num_add = 3;
                end
                num_pre = num_pre - num_com + num_com_mod;
                if isempty(num_pre); num_pre = num_nan + num_sig; end
                num_com = num_com_mod;
                
                form_type = 'e';
                num_pre = max(num_pre,num_sig+num_exp+num_com_mod+num_add);
                %form = [form_pre,num2str(num_pre),'.',num2str(num_com),form_type,form_aft];
                form = [form_pre,sprintf('%i',num_pre),'.',sprintf('%i',num_com),form_type,form_aft];
            else
                num_add = 1;
                if isempty(num_com), num_com = 0; end
                num_pre = max(num_dig + num_com + num_sig + num_add + double(~int),num_nan);
                if isempty(num_pre); num_pre = num_nan + num_sig; end
                form_type = 'f';
                %form = [form_pre,num2str(num_pre),'.',num2str(num_com),form_type,form_aft];
                form = [form_pre,sprintf('%i',num_pre),'.',sprintf('%i',num_com),form_type,form_aft];
            end
            
            %cf = @(x) sprintf(form,x);
            %C(i1,k2) = cellfun(cf,C(i1,k2),'UniformOutput',false);
            % faster
            C_tmp = C(i1,k2);
            for kC = 1:numel(C_tmp)
                C_tmp{kC} = sprintf(form,C_tmp{kC});
            end
            C(i1,k2)=C_tmp;
            
            if ~isempty(i1_split)
                i_dot = strfind(C{1,k2},'.');
                if ~isempty(i_dot)
                    C{i1_split,k2} = [repmat(' ',1,i_dot-1),C{i1_split,k2},repmat(' ',1,num_pre-i_dot)];
                else
                    n_before = num_pre-1; % floor(num_pre/2);
                    n_after  = num_pre - n_before - 1;                    
                    C{i1_split,k2} = [repmat(' ',1,n_before),C{i1_split,k2},repmat(' ',1,n_after)];
                end
            end
            
            if ~isempty(num_exp) && num_exp > 4
                fc = @(x) regexp(x,'[eE]{1}[+-]{1}\d{2}$');
                for k1 = 1:size(C,1)
                    ind = fc(C{k1,k2});
                    if ~isempty(ind)
                        C{k1,k2} = [C{k1,k2}([2:ind+1]),'0',C{k1,k2}(ind+2:ind+3)];
                    end
                end
            end
            
        end
        
    end % function

end % function






