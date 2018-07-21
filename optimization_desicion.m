function [optimization_desicion_w_v, optimization_desicion_w_i, optimization_desicion_h_v, optimization_desicion_h_i ]=optimization_desicion(U_W, U_H)		
global BP;
        outside_option_w_v = U_W(1);			%1-singe+unemployed + non-pregnant 
		outside_option_w_i = 1;
		outside_option_h_v = U_H(1);
		outside_option_h_i = 1;
		% marriage decision - outside option value wife
		if U_W(2)> outside_option_w_v 
			outside_option_w_v = U_W(2); 		%		     2-singe+unemployed + pregnant - zero for men
			outside_option_w_i = 2;
		end
		if U_W(3)> outside_option_w_v
			outside_option_w_v = U_W(3);		%            3-singe+employed + non-pregnant              
			outside_option_w_i = 3;
		end
		if U_W(4)> outside_option_w_v
			outside_option_w_v = U_W(4);		%            4-singe+employed + pregnant   - zero for men
			outside_option_w_i = 4;
		end
		if U_W(5)> outside_option_w_v
			outside_option_w_v = U_W(5);		%            5-singe+ schooling
			outside_option_w_i = 5;
		end
		% marriage decision - outside option value husband
		if U_H(3)> outside_option_h_v
			outside_option_h_v = U_H(3);		%            3-singe+employed + non-pregnant              
			outside_option_h_i = 3;
		end
		if U_H(5)> outside_option_h_v
			outside_option_h_v = U_H(5);		%            5-singe+ schooling
			outside_option_h_i = 5;
		end
		% marriage decision - choose the max out of all options
		optimization_desicion_w_v = outside_option_w_v;
		optimization_desicion_w_i = outside_option_w_i;
		optimization_desicion_h_v = outside_option_h_v; 
		optimization_desicion_h_i = outside_option_h_i;
		if (U_H(5+1)> outside_option_h_v && U_W(5+1)> outside_option_w_v)
			optimization_desicion_w_v = U_W(5+1);                                   %         1-married+man employed+women unemployed+unpregnent		
			optimization_desicion_w_i = 6;
			optimization_desicion_h_v = U_H(5+1);
			optimization_desicion_h_i = 6;
		end
		if ((U_H(5+2)> outside_option_h_v && U_W(5+2)> outside_option_w_v && optimization_desicion_w_i < 6) || ...
				(U_H(5+2)> outside_option_h_v && U_W(5+2)> outside_option_w_v && optimization_desicion_w_i > 5 && U_H(5+2)*BP+(1-BP)*U_W(5+2) > optimization_desicion_h_v*BP+(1-BP)*optimization_desicion_w_v))
			optimization_desicion_w_v = U_W(5+2);									%   		 2-married+man employed+women unemployed+pregnent		
			optimization_desicion_w_i = 7;
			optimization_desicion_h_v = U_H(5+2);
			optimization_desicion_h_i = 7;
		end
		if ((U_H(5+3)> outside_option_h_v && U_W(5+3)> outside_option_w_v && optimization_desicion_w_i < 6) || ...
				(U_H(5+3)> outside_option_h_v && U_W(5+3)> outside_option_w_v && optimization_desicion_w_i > 5 && U_H(5+3)*BP+(1-BP)*U_W(5+3) > optimization_desicion_h_v*BP+(1-BP)*optimization_desicion_w_v))
			optimization_desicion_w_v = U_W(5+3);                                                    %            3-married+man employed+women eployed+unpregnent			
			optimization_desicion_w_i = 8;
			optimization_desicion_h_v = U_H(5+3);
			optimization_desicion_h_i = 8;
		end
		if ((U_H(5+4)> outside_option_h_v && U_W(5+4)> outside_option_w_v && optimization_desicion_w_i < 6) || ...
				(U_H(5+4)> outside_option_h_v && U_W(5+4)> outside_option_w_v && optimization_desicion_w_i > 5 && U_H(5+4)*BP+(1-BP)*U_W(5+4) > optimization_desicion_h_v*BP+(1-BP)*optimization_desicion_w_v))
			optimization_desicion_w_v = U_W(5+4);													%			 4-married+man employed+women eployed+pregnent			
			optimization_desicion_w_i = 9;
			optimization_desicion_h_v = U_H(5+4);
			optimization_desicion_h_i = 9;
		end
		if ((U_H(5+5)> outside_option_h_v && U_W(5+5)> outside_option_w_v && optimization_desicion_w_i < 6) || ...
				(U_H(5+5)> outside_option_h_v && U_W(5+5)> outside_option_w_v && optimization_desicion_w_i > 5 && U_H(5+5)*BP+(1-BP)*U_W(5+5) > optimization_desicion_h_v*BP+(1-BP)*optimization_desicion_w_v))
			optimization_desicion_w_v = U_W(5+5);													%            5-married+man unemployed+women unemployed+unpregnent		
			optimization_desicion_w_i = 10;
			optimization_desicion_h_v = U_H(5+5);
			optimization_desicion_h_i = 10;
		end
		if ((U_H(5+6)> outside_option_h_v && U_W(5+6)> outside_option_w_v && optimization_desicion_w_i < 6) || ...
				(U_H(5+6)> outside_option_h_v && U_W(5+6)> outside_option_w_v && optimization_desicion_w_i > 5 && U_H(5+6)*BP+(1-BP)*U_W(5+6) > optimization_desicion_h_v*BP+(1-BP)*optimization_desicion_w_v))
			optimization_desicion_w_v = U_W(5+6);													%   		 6-married+man unemployed+women unemployed+pregnent		
			optimization_desicion_w_i = 11;
			optimization_desicion_h_v = U_H(5+6);
			optimization_desicion_h_i = 11;
		end
		if ((U_H(5+7)> outside_option_h_v && U_W(5+7)> outside_option_w_v && optimization_desicion_w_i < 6) || ...
				(U_H(5+7)> outside_option_h_v && U_W(5+7)> outside_option_w_v && optimization_desicion_w_i > 5 && U_H(5+7)*BP+(1-BP)*U_W(5+7) > optimization_desicion_h_v*BP+(1-BP)*optimization_desicion_w_v))
			optimization_desicion_w_v = U_W(5+7);                                                   %            7-married+man unemployed+women eployed+unpregnent			
			optimization_desicion_w_i = 12;
			optimization_desicion_h_v = U_H(5+7);
			optimization_desicion_h_i = 12;
		end
		if ((U_H(5+8)> outside_option_h_v && U_W(5+8)> outside_option_w_v && optimization_desicion_w_i < 6) || ...
				(U_H(5+8)> outside_option_h_v && U_W(5+8)> outside_option_w_v && optimization_desicion_w_i > 5 && U_H(5+8)*BP+(1-BP)*U_W(5+8) > optimization_desicion_h_v*BP+(1-BP)*optimization_desicion_w_v))
			optimization_desicion_w_v = U_W(5+8);													%			 8-married+man unemployed+women eployed+pregnent			
			optimization_desicion_w_i = 13;
			optimization_desicion_h_v = U_H(5+8);
			optimization_desicion_h_i = 13;
		end