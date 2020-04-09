
%écart type entre la fréquence réel et la fréquence voulu
%Justesse = écart type 
results = readmatrix('resultsSimulation2.txt');

y = [results( [5 6 7],:);results( 9,:)-results( 8,:);results(9,:)==0];

N = unique(y(1,:));
dt = unique(y(2,:));

for i= 1:length(N)
   for j = 1:length(dt)
       l(i,j) = y(4,y(1,:)==N(i) & y(2,:) == dt(j));
       t(i,j) = y(3,y(1,:)==N(i) & y(2,:) == dt(j));
   end
end

S = std(l);
J_moy = (S(5)+S(6))/2;

%Définir un barrème de score du jutesse : mesure prédit versus mesuré 15
%pourcent 
barreme = 0.15*SimulationParams.Frequence_final;
score = 0;  


function score_de_justesse(results)

   y = [results( [5 6 7],:);results( 9,:)-results( 8,:);results(9,:)==0];
   N = unique(y(1,:));
   dt = unique(y(2,:));
   score = 0;

    for i= 1:length(N)
       for j = 1:length(dt)
           l(i,j) = y(4,y(1,:)==N(i) & y(2,:) == dt(j));
           t(i,j) = y(3,y(1,:)==N(i) & y(2,:) == dt(j));
       end
    end

    S = std(l); %calcul écart-type
    J_moy = (S(5)+S(6))/2;
    bareme = 0.15*SimulationParams.Frequence_final;
    
       if J_moy < 0.01*SimulationParams.Frequence_final
           score = 100;
       end 
       
       if 0.01*SimulationParams.Frequence_final < J_moy < 0.02*SimulationParams.Frequence_final
           score = 95;
       end
       if 0.02*SimulationParams.Frequence_final < J_moy < 0.04*SimulationParams.Frequence_final
           score = 90;
       end
       if 0.04*SimulationParams.Frequence_final < J_moy < 0.06*SimulationParams.Frequence_final
           score = 85;
       end
       if 0.06*SimulationParams.Frequence_final < J_moy < 0.08*SimulationParams.Frequence_final
           score = 80;
       end
       if 0.08*SimulationParams.Frequence_final < J_moy < 0.10*SimulationParams.Frequence_final
           score = 75;
       end
       if 0.10*SimulationParams.Frequence_final < J_moy < 0.12*SimulationParams.Frequence_final
           score = 70;
       end
       if 0.12*SimulationParams.Frequence_final < J_moy < 0.14*SimulationParams.Frequence_final
           score = 65;
       end
       if 0.14*SimulationParams.Frequence_final < J_moy < 0.15*SimulationParams.Frequence_final
           score = 60;
       end
       if 0.15*SimulationParams.Frequence_final < J_moy < 0.16*SimulationParams.Frequence_final
           score = 55;
       end
       if 0.16*SimulationParams.Frequence_final < J_moy < 0.18*SimulationParams.Frequence_final
           score = 50;
       end
       if 0.18*SimulationParams.Frequence_final < J_moy < 0.20*SimulationParams.Frequence_final
           score = 45;
       end
       if 0.20*SimulationParams.Frequence_final < J_moy < 0.22*SimulationParams.Frequence_final
           score = 40;
       end
       if 0.22*SimulationParams.Frequence_final < J_moy < 0.24*SimulationParams.Frequence_final
           score = 35;
       end
       if 0.24*SimulationParams.Frequence_final < J_moy < 0.26*SimulationParams.Frequence_final
           score = 30;
       end
       if 0.26*SimulationParams.Frequence_final < J_moy < 0.28*SimulationParams.Frequence_final
           score = 25;
       end
       if 0.28*SimulationParams.Frequence_final < J_moy < 0.30*SimulationParams.Frequence_final
           score = 20;
       end
       if 0.30*SimulationParams.Frequence_final < J_moy < 0.32*SimulationParams.Frequence_final
           score = 15;
       end
       if 0.32*SimulationParams.Frequence_final < J_moy < 0.34*SimulationParams.Frequence_final
           score = 10;
       end
       if 0.34*SimulationParams.Frequence_final < J_moy < 0.36*SimulationParams.Frequence_final
           score = 5;
       end
       if 0.36*SimulationParams.Frequence_final < J_moy < 1.0*SimulationParams.Frequence_final
           score = 0;
       end
       
end
       
           
         


