function xopt=optimize_in_pos_v2(lastpos,dfmcw,dphase,initdis,initpos)
    %opt.algorithm = NLOPT_LN_COBYLA;%收敛速度比较慢，不过不需要计算梯度
    
    opt.algorithm = NLOPT_LD_MMA;%收敛速度非常快，麻烦在梯度的计算上
    %opt.algorithm = NLOPT_LD_CCSAQ;
    opt.min_objective = @(x)optimize_func_v2(x,dfmcw,dphase,initdis,initpos);
    init=[];
    for i=[1:3:length(dfmcw)]
        init=[init,lastpos];
    end
    opt.xtol_rel = 1e-6;
    opt.ftol_abs = 1e-6;
    [xopt, fmin, retcode] = nlopt_optimize(opt, init);
end