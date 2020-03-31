
x = [1:25];
xi = linspace(0, 26, 150);

%h = figure;

%On choisit les axes en fonction de ymax
%ymax = 1.25*max(max(max(out.corde_mesure)),max(abs(out.corde_mesure)))

%filename = 'testAnimated.gif'
for k = 1 :50: length(out.corde_mesure.Time)
    y = out.corde_mesure.Data(k,x);
    yi = interp1([0 x 26], [0 y 0], xi, 'spline', 'extrap');
    plot(xi, yi, '-r');
    title('Animation de la corde');
    hold off
    grid
    xlim([0 26])
    ylim([-1*0.003 0.003])
    xlabel('Segments de corde')
    ylabel('Position')
    drawnow
    pause( 0.0001 );
    
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