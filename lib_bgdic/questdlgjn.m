function Button=questdlgjn(Question,Title,Btn1,Btn2,Default,Position)
% function similar to questdlg, except simpler and with the option to
% position it.

if ~iscell(Question)
    Question = {Question};
end

fontsize = 14;
N = length(Question);
M = max(cellfun('length',Question));

Figheight = N*2*fontsize + 2*fontsize;
Figwidth = M*0.6*fontsize + 2*fontsize;
Figpos(3:4) = [Figwidth Figheight];
Figpos(1:2) = Position - 0.5*Figpos(3:4);

FigColor=get(0,'DefaultUicontrolBackgroundColor');
WindowStyle='modal';
Interpreter='none';
Resize = 'off';

H =    dialog(                     ...
  'Visible'          ,'on'      , ...
  'Name'             ,Title      , ...
  'Pointer'          ,'arrow'    , ...
  'Units'            ,'pixels'   , ...
  'UserData'         ,'Cancel'   , ...
  'Tag'              ,Title      , ...
  'HandleVisibility' ,'callback' , ...
  'Color'            ,FigColor   , ...
  'NextPlot'         ,'add'      , ...
  'WindowStyle'      ,WindowStyle, ...
  'Resize'           ,Resize,      ...
  'Position'         ,Figpos       ...
  );


xpos = linspace(0.08,0.92,4);
ypos(1) = 0.08;
ypos(2) = ypos(1) + 0.05 + 2/(2*N+2);
height = 1.8/(1.5*N+2);
width = 0.9*mean(diff(xpos));

% Create title
uicontrol('String',Question,...
    'Style','text',...
    'HorizontalAlignment','left',...
    'units','normalized',...
    'Position',[xpos(1) ypos(2) xpos(end)-xpos(1) 1-(ypos(2)+0.06)],...
    'FontSize',fontsize,...
    'Parent',H);

uicontrol('String',Btn1,...
    'Style','pushbutton',...
    'units','normalized',...
    'Position',[xpos(1) ypos(1) width height],...
    'FontSize',fontsize,...
    'Parent',H,...
    'call',{@pressBut1,H});

uicontrol('String',Btn2,...
    'Style','pushbutton',...
    'units','normalized',...
    'Position',[xpos(2) ypos(1) width height],...
    'FontSize',fontsize,...
    'Parent',H,...
    'call',{@pressBut2,H});

uicontrol('String','Cancel',...
    'ToolTipString','cancel input',...
    'Style','pushbutton',...
    'units','normalized',...
    'Position',[xpos(3) ypos(1) width height],...
    'FontSize',fontsize,...
    'Parent',H,...
    'call',{@pressCancel,H});


set(H,'KeyPressFcn',{@doFigureKeyPress,H})

uiwait(H)

if ishandle(H)
    Button = guidata(H);
    if Button == 1
        Button = Btn1;
    elseif Button == 2
        Button = Btn2;
    elseif Button == 3
        Button = Default;
    end
    delete(H);
else
    Button = [];
end

function doFigureKeyPress(obj, evd, H) %#ok
switch(evd.Key)
  case {'return','space'}
      pressDefault([],[],H);
  case {'escape'}
      pressCancel([],[],H);
end

function pressBut1(varargin)
H = varargin{3};
guidata(H,1);
uiresume(H);

function pressBut2(varargin)
H = varargin{3};
guidata(H,2);
uiresume(H);

function pressCancel(varargin)
H = varargin{3};
guidata(H,[]);
uiresume(H);

function pressDefault(varargin)
H = varargin{3};
guidata(H,3);
uiresume(H);


