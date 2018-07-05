function [ah] = showmata(varargin)
% Hilfsroutine zum Visualisieren von Arrays in einer Figure.
% 
% Aufruf: showmata(a,b,c,...)
% 
% Die Matrizen werden als Images in einer Figure
% dargestellt, wobei die Farbcodierung zur Verbesserung der
% Vergleichbarkeit in allen Achsen identisch ist.
%
% Falls nan (Not a Number) in dem Array enthalten ist, wird die Farbskala
% um den Wert fuer Weiss erweitert und nan in dieser Farbe dargestellt. 
%
% Winfried Kernbichler  29.03.2003
%
% Veraenderungen: ah = showmata(a,b,c,...)
% Es werden die AxesHandles zurückgegeben.
%
% Armin Moser 26.03.2006

% Interne Veraenderung: Es wird keine figure mehr initialisiert
%                       clf reset auskommentiert da Probleme mit MLTutor
%                       Stat figure-handle wird gcf verwendet
%
% Armin Moser 14.04.2008
% Beim setzen der Figure Properties wird die Position nicht mehr gesetzt

  cmax = -inf;
  cmin = inf;
  nanstat = 0;
  doustat = 0;
  
  nvin = length(varargin);
  
  for k = 1:nvin
    mat = varargin{k};
    cmaxk = max(mat(:));
    cmink = min(mat(:));
    if cmink >= cmaxk; cmink = cmaxk-1; end
    cmax = max(cmax,cmaxk);
    cmin = min(cmin,cmink);
    
    % Ueberpruefung, ob nan enthalten ist
    nanstatk = isnan(mat);
    nanstatk = any(nanstatk(:));
    nanstat  = nanstat | nanstatk;
    
    % Ueberpruefung, ob nicht integer werte enthalten sind
    doustatk = mod(mat,1);
    doustatk = any(doustatk(:));
    doustat  = doustat | doustatk;
  end
  
  % figure
  %  fh = figure(1); clf reset;
  set(gcf,'MenuBar','none','NumberTitle','on','Name','showmat',...
	 'Units','normalized') ; %,'Position',[0.1,0.2,0.8,0.7]);
  % axes
  xax_dist = 0.05;
  xax_len  = 1/nvin - 2*xax_dist;
  yax_dist = 0.2;
  yax_len  = 0.75;
  
  yax_cb1  = 0.075;
  yax_cb2  = 0.05;
  
  for k = 1:nvin
    mat = varargin{k};
   
    % image and axis
    ah(k) = axes('Position',[xax_dist+(k-1)*1/nvin,yax_dist,xax_len,yax_len]);
    ih(k) = imagesc(mat);
    try axis equal; end 
    axis tight; 
    axis on;
    set(ah(k),'TickLength',[0,0]);
    
    x_lim   = get(ah(k),'XLim');
    y_lim   = get(ah(k),'YLim');
    xy_lim_max = 75;
    if max(diff(x_lim),diff(y_lim))<=xy_lim_max, 
      x_grid  = linspace(x_lim(1),x_lim(2),size(mat,2)+1);
      y_grid  = linspace(y_lim(1),y_lim(2),size(mat,1)+1);
      [xx,yy] = meshgrid(x_grid,y_grid);
      ph_v{k}    = line(xx,yy,'Color',[0,0,0]);
      ph_h{k}    = line(xx.',yy.','Color',[0,0,0]);
    end
    
    % tickmarks and ticklabels for the axis containing the image
    xtick  = 1:size(mat,2);
    ytick  = 1:size(mat,1);
    xt_len = length(xtick);
    yt_len = length(ytick);
    xt_inc = max([1,floor(xt_len/10)]);
    yt_inc = max([1,floor(yt_len/10)]);
    xt_inc = xt_inc * ceil(diff(y_lim)/diff(x_lim));
    yt_inc = yt_inc * ceil(diff(x_lim)/diff(y_lim));
    xtick  = fliplr(xtick(xt_len:-xt_inc:1));
    ytick  = fliplr(ytick(yt_len:-yt_inc:1));
    xtickl = cellstr(num2str(transpose(xtick)));
    ytickl = cellstr(num2str(transpose(ytick)));
    set(ah(k),'XTick',xtick,'YTick',ytick);
    set(ah(k),'XTickLabel',xtickl,'YTickLabel',ytick);

    % color
    max_color = 256;
    h_mult    = 0.72;
    h_pow     = 1.6;
    s_mult    = 1.0; s_min = 0.7; s_max = 1.0; s_pow = 1.5;
    v_mult    = 1.0; v_min = 0.9; v_max = 1.0; v_pow = 1.5;
    h_val     = (linspace(0,1,max_color).').^h_pow*h_mult;
    %s_val     = ones(max_color,1)*s_mult;
    s_val     = (1-sin(linspace(0,pi,max_color).')).^s_pow*(s_max-s_min)+s_min;
    %v_val     = ones(max_color,1)*v_mult;
    v_val     = (sin(linspace(0,pi,max_color).')).^v_pow*(v_max-v_min)+v_min;
    jet_color =hsv2rgb([h_val, s_val, v_val]);
    
    % if only integer values reduce colormap
    if ~doustat & cmax-cmin+1 < max_color
      jet_index = floor(linspace(1,max_color,cmax-cmin+1));
      jet_color = jet_color(jet_index,:);
    end
    map = colormap(jet_color);
    
    
    
    % enlarge colormap with white (for nan)
    if nanstat
      white = [1,1,1];
      map = [white;map];
      if doustat | cmax-cmin+1 >= max_color
	cmin = cmin - (cmax-cmin)/(size(map,1)-2);
      else
	cmin = cmin - 1;
      end
    end
    
    caxis([cmin,cmax]);
    colormap(map);

  end
   
  caxis([cmin,cmax]);
  
  % colorbar - vertical does not work
  cb_dir = {'horiz','vert'};
  cb_dir = cb_dir{1};
  switch cb_dir
      case 'horiz'
         cobh = colorbar('peer',ah(1),'location','southoutside');
      case 'vert'
         cobh = colorbar('peer',ah(1),'location','eastoutside');
  end
  set(cobh,'Position',[xax_dist,yax_cb1,1-2*xax_dist,yax_cb2])
  
  % modify colorbar for integer arrays
  if ~doustat
    col_anz  = size(map,1);
    col_inc  = max(1,floor(col_anz/10));
    col_dist = abs( (cmax-cmin) / col_anz );
    col_beg  = cmin + col_dist / 2;
    switch cb_dir
     case 'horiz'
      xtick    = [col_beg:col_dist:cmax];
      xtick    = xtick(1:col_inc:end);
      xtickl   = transpose(floor([cmin:cmax]));
      xtickl   = xtickl(1:col_inc:end);
      xtickl   = cellstr(num2str(xtickl));
      if nanstat, xtickl{1} = 'NaN'; end      
      set(cobh,'XTick',xtick);
      set(cobh,'XTickLabel',xtickl);
     case 'vert'
      ytick    = [col_beg:col_dist:cmax];
      ytick    = ytick(1:col_inc:end);
      ytickl   = transpose(floor([cmin:cmax]));
      ytickl   = ytickl(1:col_inc:end);
      ytickl   = cellstr(num2str(ytickl));
      if nanstat, ytickl{1} = 'NaN'; end      
      set(cobh,'YTick',ytick);
      set(cobh,'YTickLabel',ytickl);
    end
  end
  %set(cobh,'TickLength',[0,0]);
 
  