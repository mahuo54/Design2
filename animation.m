
x = [1:23];
xi = linspace(min(x), max(x), 150); 

%h = figure;

%On choisit les axes en fonction de ymax
ymax = 1.25*max(max(max(position_21)),max(abs(min(position_21))))

%filename = 'testAnimated.gif'
for k = 1 : length(position_21.Time)
    y = position_21.Data(k,x);
    yi = interp1(x, y, xi, 'spline', 'extrap');
  plot(xi, yi, '-r');
  title('Animation de la corde');
  hold off
  grid
  xlim([1 23])
  ylim([-1*ymax ymax])
  xlabel('Segments de corde')
  ylabel('Position')
  pause( 0.0005 );
  
  %Faire un GIF
  %frame = getframe(h); 
     % im = frame2im(frame); 
     % [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
     % if k == 1 
      %    imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
     % else 
     %     imwrite(imind,cm,filename,'gif','WriteMode','append'); 
    %  end 
end
hold off