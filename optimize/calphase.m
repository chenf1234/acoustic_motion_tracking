function N=calphase(initphase,f0,B,T,D)
%使用nlopt计算初始2Npi偏移,与millisonic复现相关
    opt.algorithm = NLOPT_LN_COBYLA;
    opt.min_objective = @(x)calphase_func(x,initphase,f0,B,T,D);
    opt.xtol_rel = 1e-6;
    opt.ftol_abs = 1e-6;
    [N, fmin, retcode] = nlopt_optimize(opt, 0);
    %disp(fmin);
end