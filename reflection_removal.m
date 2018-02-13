function [TL,RL] = reflection_removal(I,lambda)

% lambda: control the smoothness
% TL: Transmission Layer;
% Rl: Reflection Layer;

%% Initializations

S = size(I);
image_size = S(1,1:2);

repmat_dimension = [1 1 S(1,3)];

filter1 = [1 -1];
filter2 = [1; -1];
filter3 = [0 -1 0; -1 4 -1; 0 -1 0];


%% Pre-computing Numerator and Denominator Coefficients for A viz. (FFT(TL))

coeff_lambda_num = repmat(abs(psf2otf(filter3,image_size)),repmat_dimension).^2.*fft2(I);

coeff_lambda_den = repmat(abs(psf2otf(filter3,image_size)).^2,repmat_dimension) ;

coeff_beta_den = repmat(abs(psf2otf(filter1,image_size)).^2 + abs(psf2otf(filter2,image_size)).^2,repmat_dimension);


%% MAIN PROCEDURE

sol_lower_bound = zeros(S);
sol_upper_bound = I;
tau = 1e-16;
beta = 20;
TL = I;
max_iter = 5;

while max_iter
    max_iter = max_iter - 1;
    
    %% Updation of Auxilliary Variables (g)
    
    g1 = -imfilter(TL,filter1,'circular');
    g1(repmat(sum(abs(g1),3)<1/beta,repmat_dimension)) = 0;
    g2 = -imfilter(TL,filter2,'circular');
    g2(repmat(sum(abs(g2),3)<1/beta,repmat_dimension)) = 0;

    %% Computation and Normalization of Transmission Layer (TL)
    
    coeff_beta_num = [g1(:,end,:)-g1(:, 1,:),(-diff(g1,1,2))] + [g2(end,:,:)-g2(1,:,:);(-diff(g2,1,1))];
    
    num_A = beta*fft2(coeff_beta_num) + lambda*coeff_lambda_num; 
    den_A = beta*coeff_beta_den + lambda*coeff_lambda_den + tau;
    
    A = num_A./den_A;
    
    TL = real(ifft2(A));
    
    for i = 1:repmat_dimension(1,3)
        
        TL_t = TL(:,:,i);
        iter = 100;
        threshold = 1/numel(TL_t);
        
        while iter
            iter = iter - 1;
            dt_num_A = sum(TL_t(TL_t < sol_lower_bound(:,:,i)));
            dt = -2*(dt_num_A + sum(TL_t(TL_t > sol_upper_bound(:,:,i))))/numel(TL_t);
            TL_t = TL_t + dt;
            if abs(dt) < threshold
                break;
            end   
        end
        
        TL(:,:,i) = TL_t;
        
    end
    
    TL(TL < sol_lower_bound) = sol_lower_bound(TL < sol_lower_bound);
    TL(TL > sol_upper_bound) = sol_upper_bound(TL > sol_upper_bound);
    
    beta = beta * 2;
end

RL = I - TL;

end

