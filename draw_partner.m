function[CHOOSE_PARTNER PARTNER_N  ability_p  PS  P_HSD P_HSG P_SC P_CG P_PC year_of_school_p PK  prev_state_p capacity_p PARTNER_P  P_GOOD  P_FAIR  P_POOR  P_HEALTH  Q_UTILITY_PERMANENT]= ...
             draw_partner(t, draw_f_or_b ,age, in_school_at_t_minus_1, IND_S, h_draws, w_draws,  husband_prev_kids, husband_prev_emp,wife_prev_kids, wife_prev_emp, health_h, health_w, sex) 
global omega1; global omega2; global omega3; global omega4_w; global omega5_w; global omega6_w; global omega7_w; global omega8_w;
global omega4_h; global omega5_h; global omega6_h; global omega7_h; global omega8_h;
global omega9_w ;global omega10_w ;global omega9_h ;global omega10_h ;global sigma;
global normal_arr; global p_education; global GOOD;	 global FAIR; global POOR;global HK1 ;   global HK2 ;	global HK3 ;global HK4 ;
CHOOSE_PARTNER=0; PARTNER_N=0;   ability_p=0;   PS=0;   P_HSD=0;  P_HSG=0;  P_SC=0;  P_CG=0;  P_PC=0;  year_of_school_p=0;  PK=0;   
prev_state_p=0; capacity_p = 0;  PARTNER_P=0;   P_GOOD=0;   P_FAIR=0;   P_POOR=0;   P_HEALTH=GOOD;  Q_UTILITY_PERMANENT=0; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    prob of meeting a husband
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (sex == 1)   % choose husband
    match_educ_prob=zeros(3);
    match_educ_prob(1,1) = exp(omega4_w)/(1+exp(omega4_w)+exp(omega7_w));                           %probability of meeting cg if cg
    match_educ_prob(1,2) = exp(omega7_w)/(1+exp(omega4_w)+exp(omega7_w));                           %probability of meeting sc if cg
    match_educ_prob(1,3) = 1/(1+exp(omega4_w)+exp(omega7_w));                                       %probability of meeting hs if cg
    match_educ_prob(2,1) = exp(omega4_w+omega5_w)/(1+exp(omega4_w+omega5_w)+exp(omega7_w));         %probability of meeting cg if sc
    match_educ_prob(2,2) =          exp(omega7_w)/(1+exp(omega4_w+omega5_w)+exp(omega7_w));         %probability of meeting sc if sc
    match_educ_prob(2,3) =                      1/(1+exp(omega4_w+omega5_w)+exp(omega7_w));         %probability of meeting hs if sc
    match_educ_prob(3,1) = exp(omega4_w+omega6_w)/(1+exp(omega4_w+omega6_w)+exp(omega7_w+omega8_w));%probability of meeting cg if hs
    match_educ_prob(3,2) = exp(omega7_w+omega8_w)/(1+exp(omega4_w+omega6_w)+exp(omega7_w+omega8_w));%probability of meeting sc if hs
    match_educ_prob(3,3) =                      1/(1+exp(omega4_w+omega6_w)+exp(omega7_w+omega8_w));%probability of meeting hs if hs
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % if not married DRAW HUSBAND + HUSBAND CHARACTERISTICS		
        %h_draws = rand(DRAW_F,T,5); 1- MEET HUSBAND;2-HUSBAND SCHOOLING+EXP; 3-HUSBAND ABILITY; 4 - HUSBAND CHILDREN; 5 - HEALTH ; 6 - PARENTS EDUCATION; 7 - job offer;8-part time/full time; 9- prev state husband
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (age < 20)
        temp = (exp(omega1))/(1+exp(omega1));
    elseif (in_school_at_t_minus_1 == 1 && age>19)
        temp1= omega2 + omega9_w*age + omega10_w*age*age;
        temp = (exp(temp1))/(1+exp(temp1));
    else
        temp1= omega3 + omega9_w*age + omega10_w*age*age;
        temp = (exp(temp1))/(1+exp(temp1));
    end
    if (h_draws(draw_f_or_b,t,1)>temp)  % probability of meeting potential partner a function of age and whether completed schoolings
        CHOOSE_PARTNER = 0;
        PARTNER_N = 0;
    else %   meet potential husband
        CHOOSE_PARTNER = 1;
        ability_p = normal_arr(h_draws(draw_f_or_b,t,3))*sigma(2,2); % draw potential partner ability
        % draw husband educ 
        husbans_p=zeros(1,3);
        WS = IND_S;
        if ((WS>0) &&(WS < 3))
            husbans_p=match_educ_prob(3,:);
        elseif (WS ==3)
            husbans_p=match_educ_prob(2,:);
        elseif ((WS >3) && (WS<6))
            husbans_p=match_educ_prob(1,:);
        else
            error(0);
        end	
        if (h_draws(draw_f_or_b,t,2)<husbans_p(1));%husband schooling HSD
            if (WS>1)
                PS = 2;
                P_HSG=1;
                year_of_school_p = 12;
            else
                PS = 1;
                P_HSD=1;
                year_of_school_p = 11;
             end
        elseif (h_draws(draw_f_or_b,t,2)>husbans_p(1)  &&  h_draws(draw_f_or_b,t,2)<(husbans_p(1)+husbans_p(2))  );%husband schooling HSD
                PS = 3;
                P_SC = 1;
                year_of_school_p = 14;
        elseif (h_draws(draw_f_or_b,t,2)>(husbans_p(1)+husbans_p(2)) );%husband schooling PC
            if (WS<5)
                PS = 4;
                P_CG = 1;
                year_of_school_p = 15;
            else
                PS = 5;
                P_PC = 1;
                year_of_school_p = 17;
            end
        end    
        %  choose potential experience for husband
        pot_exp = age - year_of_school_p - 6;
        if (pot_exp < 3)
            PK = HK1;    %HK1 = 1;                              %0-2 years of experience

        elseif (pot_exp  > 2  && pot_exp <7 )
            PK = HK2;    %HK2 = 4;	                          %3-5 years of experience
        elseif (pot_exp  > 6  && pot_exp <10 )
            PK = HK3;    %HK3 = 8;	                          %6-10 years of experience
        elseif (pot_exp  > 9   )
            PK = HK4;    %HK4 = 12;	                          %11+ years of experience               
        else
            error(0)    
        end  
        % draw previous state for husband
        if (h_draws(draw_f_or_b,t,9)<husband_prev_emp(t))
            prev_state_p = 1;
            capacity_p = 1;
        elseif (h_draws(draw_f_or_b,t,9)>= husband_prev_emp(t))
            prev_state_p = 0;
        else
            error(0);
        end
        % draw potential partner children
        PARTNER_N = 0;
        if (h_draws(draw_f_or_b,t,4)<husband_prev_kids(t,1))
            PARTNER_N = 0;
        elseif (h_draws(draw_f_or_b,t,4)>husband_prev_kids(t,1))
            PARTNER_N = 1;
        else
            error(0);
        end
        if (h_draws(draw_f_or_b,t,6)<p_education)
            PARTNER_P = 1;   % husband's parents have collage education
        else 
            PARTNER_P = 0; %husband's parents have only high school education
        end	
        % draw husband or potential husband health
        P_GOOD = 0; P_FAIR = 0; P_POOR = 0;
        if (h_draws(draw_f_or_b,t,5)<health_h(t,2))
            P_HEALTH = GOOD;
            P_GOOD = 1;
        elseif (h_draws(draw_f_or_b,t,5)>health_h(t,2) && h_draws(draw_f_or_b,t,5)<health_h(t,3))
            P_HEALTH = FAIR;
            P_FAIR = 1;
        elseif (h_draws(draw_f_or_b,t,5)>health_h(t,3) && h_draws(draw_f_or_b,t,5)<health_h(t,4))
            P_HEALTH = POOR;
            P_POOR = 1;
        else
            error(0);
        end	
    end  % close if got an offer - at this stage if CHOOSE_PARTNER=1 we already draw all marriage characteristics - M vector at paper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    prob of meeting a wife
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else      % choose wife
   match_educ_prob=zeros(3);
    match_educ_prob(1,1) = exp(omega4_h)/(1+exp(omega4_h)+exp(omega7_h));
    match_educ_prob(1,2) = exp(omega7_h)/(1+exp(omega4_h)+exp(omega7_h));
    match_educ_prob(1,3) = 1/(1+exp(omega4_h)+exp(omega7_h));
    match_educ_prob(2,1) = exp(omega4_h+omega5_h)/(1+exp(omega4_h+omega5_h)+exp(omega7_h));
    match_educ_prob(2,2) =          exp(omega7_h)/(1+exp(omega4_h+omega5_h)+exp(omega7_h));
    match_educ_prob(2,3) =                      1/(1+exp(omega4_h+omega5_h)+exp(omega7_h));
    match_educ_prob(3,1) = exp(omega4_h+omega6_h)/(1+exp(omega4_h+omega6_h)+exp(omega7_h+omega8_h));
    match_educ_prob(3,2) = exp(omega7_h+omega8_h)/(1+exp(omega4_h+omega6_h)+exp(omega7_h+omega8_h));
    match_educ_prob(3,3) =                      1/(1+exp(omega4_h+omega6_h)+exp(omega7_h+omega8_h));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % if not married DRAW HUSBAND + HUSBAND CHARACTERISTICS		
        %h_draws = rand(DRAW_F,T,5); 1- MEET HUSBAND;2-HUSBAND SCHOOLING+EXP; 3-HUSBAND ABILITY; 4 - HUSBAND CHILDREN; 5 - HEALTH ; 6 - PARENTS EDUCATION; 7 - job offer;8-part time/full time; 9- prev state husband
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (age < 20)
        temp = (exp(omega1))/(1+exp(omega1));
    elseif (in_school_at_t_minus_1 == 1 && age>19)
        temp1= omega2 + omega9_h*age + omega10_h*age*age;
        temp = (exp(temp1))/(1+exp(temp1));
    else
        temp1= omega3 + omega9_h*age + omega10_h*age*age;
        temp = (exp(temp1))/(1+exp(temp1));
    end
    if (w_draws(draw_f_or_b,t,4+1)>temp)  % probability of meeting potential partner a function of age and whether completed schoolings
        CHOOSE_PARTNER = 0;
        Q_UTILITY_PERMANENT = 0;
        PARTNER_N = 0;
    else %   meet potential husband
        CHOOSE_PARTNER = 1;
        Q_UTILITY_PERMANENT =  w_draws(draw_f_or_b,t,4);%  permanent component that is a part of the marriage offer
        ability_p = normal_arr(w_draws(draw_f_or_b,t,4+3))*sigma(2,2); % draw potential partner ability
        % draw husband educ 
        wife_p=zeros(1,3);
        WS = IND_S;
        if ((WS>0) &&(WS < 3))
            wife_p=match_educ_prob(3,:);
        elseif (WS ==3)
            wife_p=match_educ_prob(2,:);
        elseif ((WS >3) && (WS<6))
            wife_p=match_educ_prob(1,:);
        else
            error(0);
        end	
        if (w_draws(draw_f_or_b,t,4+2)<wife_p(1));%husband schooling HSD
            if (WS>1)
                PS = 2;
                P_HSG=1;
                year_of_school_p = 12;
            else
                PS = 1;
                P_HSD=1;
                year_of_school_p = 11;
             end
        elseif (w_draws(draw_f_or_b,t,4+2)>wife_p(1)  &&  w_draws(draw_f_or_b,t,4+2)<(wife_p(1)+wife_p(2))  );%husband schooling HSD
                PS = 3;
                P_SC = 1;
                year_of_school_p = 14;
        elseif (w_draws(draw_f_or_b,t,4+2)>(wife_p(1)+wife_p(2)) );%husband schooling PC
            if (WS<5)
                PS = 4;
                P_CG = 1;
                year_of_school_p = 15;
            else
                PS = 5;
                P_PC = 1;
                year_of_school_p = 17;
            end
        end    
        %  choose potential experience for husband
        pot_exp = age - year_of_school_p - 6;
        if (pot_exp < 3)
            PK = HK1;    %HK1 = 1;                              %0-2 years of experience
        elseif (pot_exp  > 2  && pot_exp <7 )
            PK = HK2;    %HK2 = 4;	                          %3-5 years of experience
        elseif (pot_exp  > 6  && pot_exp <10 )
            PK = HK3;    %HK3 = 8;	                          %6-10 years of experience
        elseif (pot_exp  > 9   )
            PK = HK4;    %HK4 = 12;	                          %11+ years of experience               
        else
            error(0)    
        end  
        % draw previous state for husband
        if (w_draws(draw_f_or_b,t,4+7)<wife_prev_emp(t))
            prev_state_p = 1;
        elseif (w_draws(draw_f_or_b,t,4+7)>= wife_prev_emp(t))
            prev_state_p = 0;
        else
            error(0);
        end
        % draw potential partner children
        PARTNER_N = 0;
        if (w_draws(draw_f_or_b,t,4+4)<wife_prev_kids(t,1))
            PARTNER_N = 0;
        elseif (w_draws(draw_f_or_b,t,4+4)>wife_prev_kids(t,1))
            PARTNER_N = 1;
        else
            error(0);
        end
        if (w_draws(draw_f_or_b,t,4+6)<p_education)
            PARTNER_P = 1;   % husband's parents have collage education
        else 
            PARTNER_P = 0; %husband's parents have only high school education
        end	
        % draw husband or potential husband health
        P_GOOD = 0; P_FAIR = 0; P_POOR = 0;
        if (w_draws(draw_f_or_b,t,4+5)<health_w(t,2))
            P_HEALTH = GOOD;
            P_GOOD = 1;
        elseif (w_draws(draw_f_or_b,t,4+5)>health_w(t,2) && w_draws(draw_f_or_b,t,4+5)<health_w(t,3))
            P_HEALTH = FAIR;
            P_FAIR = 1;
        elseif (w_draws(draw_f_or_b,t,4+5)>health_w(t,3) && w_draws(draw_f_or_b,t,4+5)<health_w(t,4))
            P_HEALTH = POOR;
            P_POOR = 1;
        else
            error(0);
        end	
    end  % close if got an offer - at this stage if CHOOSE_PARTNER=1 we already draw all marriage characteristics - M vector at paper
end    

