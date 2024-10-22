function[aviao,mortes] = Reynolds(run,geom,perfil,aviao,mortes)

    rho = run.rho;
    Velocidade = run.Q;
    mu = run.mu;
    corda_raiz = geom.corda_raiz;
    taper = geom.t;
    perfis = geom.perfis;
    n = length(perfis);
    corda_ponta = zeros(1,n);
    for i = 1:n
        corda_ponta(1) = corda_raiz;
        n_perfil = perfis(i);        
        corda_ponta(i+1) = corda_ponta(i)*taper(i);       
        Re = rho*Velocidade*corda_ponta(i+1)/mu;     
        
        if Re < perfil(n_perfil).Re
            aviao.morte = 1;
            mortes.reynolds = 1;
        end
    end

end