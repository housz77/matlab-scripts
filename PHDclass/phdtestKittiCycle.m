%% motion model
rng(2000)
T = 0.1;
F = [1 0 T 0; 0 1 0 T; 0 0 1 0; 0 0 0 1];
q = 50;
Q = [(q*T^3)/3  0           (q*T^2)/2   0;
     0          (q*T^3)/3   0           (q*T^2)/2;
     (q*T^2)/2  0           q*T         0;
     0          (q*T^2)/2   0           q*T];

H = [1 0 0 0;...
     0 1 0 0];
R = 0.0001*diag([1 1]);
 
%create 2d measurements and prepare the isObject cell array
n = 40;
Z = cell(1,n);
ZCar = cell(1,n);
isObject = cell(1,n);
allMeas = [];
for i = 1:n
    meas = [];
    measIsObject = [];
    for j = 1:length(clusters{i})
        center = mean(clusters{i}{j},1);
        meas = [meas center(1:2)'];
    end
    Z{i} = meas;
    isObject{i} = isCarMat(i,:);
    allMeas = [allMeas meas];
end

%plot the measurements
figure
plot(allMeas(1,:),allMeas(2,:),'x','Color',[0.3 0.3 0.3])

%% init
ps = 0.99;
pd = 0.98;

means = cell(1,5);
covariances = cell(1,5);
weights = cell(1,5);
means{1} = [10.2 7.4 4 -6]';
means{2} = [22.9 20.4 4 -3]';
means{3} = [-20 -17 1 1]';
means{4} = [-18 -5 0 0]';
means{5} = [-4 -6 0 0]';
covariances{1} = 2*diag(ones(1,4));
covariances{2} = 2*diag(ones(1,4));
covariances{3} = 2*diag(ones(1,4));
covariances{4} = 2*diag(ones(1,4));
covariances{5} = 5*diag(ones(1,4));
weights{1} = 1;
weights{2} = 1;
weights{3} = 1;
weights{4} = 1;
weights{5} = 3;

%% filter recursion
phd_filter = PHDfilter;
phd_filter.set_birth_rfs(means, covariances, weights);
phd_filter.set_model_parameters(F,Q,H,R);

for i=1:n
    i
    figure(1);
    pcshow(clusteredPC{i})
    zoom(2)
    %plot(ZCar{i}(1,:),ZCar{i}(2,:),'x','Color',[0.3 0.3 0.3])
    hold on
    phd_filter.predict;
    phd_filter.update(Z{i},isObject{i})
    phd_filter.get_number_of_targets
    est = phd_filter.get_best_estimates;
    
    %plot the current estimates
    if ~isempty(est)
        for j=1:length(est)
            rng(est(j).index)
            color =  [rand, rand, rand]; 
            plot(est(j).mu(1), est(j).mu(2),'x','Color',color)
            testtxt = strcat('\leftarrow target: ', num2str(est(j).index));
            text(double(est(j).mu(1)), double(est(j).mu(2)), testtxt)
        end
    end
    hold off
    pause(0.2)
end

%% 
%plot the current gaussians
gaussians = phd_filter.get_all_gaussians;
[x1,x2,x3] = threeSigmaOverGrid(gaussians(1).mu(1:2),gaussians(1).P(1:2,1:2));
plot(x3(1,:),x3(2,:),' --k')