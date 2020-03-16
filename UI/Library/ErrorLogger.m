classdef ErrorLogger
    %ERRORLOGGER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        StatutLabel;
        UIFigure;
    end
    
    methods
        function obj = ErrorLogger(StatutLabel,UIFigure)
            obj.StatutLabel = StatutLabel;
            obj.UIFigure = UIFigure;
        end
        
        function Warn(obj, message)
            uialert(obj.UIFigure ,message,'Avertissement');
            obj.StatutLabel.Text = sprintf('Statut : %s', message);
        end
    end
end

