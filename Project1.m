close all; clear all;
q1=180; q2=0; q3=-180; x=17; y=5.5; z=-19.25;
a2=17; a3=0; d3=5.5; d4=17.05;d2=9.2;L3=17.05;
alp=[0 -90 0 -90 90 -90];
a=[0 0 a2 a3 0 0];
d=[0 0 d3 d4 0 0];
dE=[0;0;2.2];
% d=d2-d3;
d1=0;
Rz=[cosd(q1) -sind(q1) 0;
    sind(q1) cosd(q1) 0;
    0 0 1];
Rx=[1 0 0;
    0 cosd(q2) -sind(q2);
    0 sind(q2) cosd(q2)];
Ry=[cosd(q3) 0 sind(q3);
    0 1 0;
    -sind(q3) 0 cosd(q3)];
  Rzxy= Rz*Rx*Ry;
%  Rzxy=[-0.747244734311603,0.471388602353616,-0.468420849893219;0.645928320684291,0.349506605651408,-0.678691194243746;-0.156211112221740,-0.809714714067328,-0.565650218988123];
 Pe=[x;y;z];
%    Pe=[-1.570692421794338;-7.665940944086812;7.042300342185204];
O6=Pe-Rzxy*dE;
ymin=-20; ymax=20; zmin=-20; zmax=20; xmin=-20; xmax=20;
xc=O6(1);yc=O6(2);zc=O6(3);
% % theta1***************
 the1_L= atan2d(yc,xc)- atan2d(d3,sqrt(xc^2+yc^2-d3^2));
 the1_R=atan2d(yc,xc)+180+ atan2d(d3,sqrt(xc^2+yc^2-d3^2));

 % the1_R=180+the1_L;

s=zc-d1;
u=sqrt(xc^2+yc^2-d3^2);
D=(u^2+s^2-a2^2-d4^2)/(2*a2*d4);

% theta3****************
the3_L=atan2d(sqrt(1-D^2),D);
the3_R=atan2d(-sqrt(1-D^2),D);

% % theta1***************
%  the1_L= atan2d(yc,xc)- atan2d(d3,a2+d4*cosd(the3_L));
%  the1_R=atan2d(yc,xc)+180+ atan2d(d3,a2+d4*cosd(the3_R));


%  the1_R=180+the1_L;
% theta2****************
the2_L= atan2d(s,u)-atan2d(L3*sind(the3_L),a2+L3*cosd(the3_L));
the2_R= atan2d(s,u)-atan2d(L3*sind(the3_R),a2+L3*cosd(the3_R));

DH1=[the1_L the2_L the3_L];
DH2=[the1_L the2_R the3_R];
DH3=[the1_R the2_L the3_L];
DH4=[the1_R the2_R the3_R];
q=[DH1;DH2;DH3;DH4];
for j=1:4
    
    %     Ttemp(:,:,j)=eye(4);
    Ttemp=eye(3);
    for i=1:3
        T=[cosd(q(j,i)) -sind(q(j,i)) 0;
            sind(q(j,i))*cosd(alp(i)) cosd(q(j,i))*cosd(alp(i)) -sind(alp(i));
            sind(q(j,i))*sind(alp(i)) cosd(q(j,i))*sind(alp(i)) cosd(alp(i))];
        %          T=[cosd(q(j,i)) -sind(q(j,i)) 0 a(i);
        %             sind(q(j,i))*cosd(alp(i)) cosd(q(j,i))*cosd(alp(i)) -sind(alp(i)) -d(i)*sind(alp(i));
        %             sind(q(j,i))*sind(alp(i)) cosd(q(j,i))*sind(alp(i)) cosd(alp(i)) d(i)*cosd(alp(i));
        %             0 0 0 1];
        %         To(:,:,i)=Ttemp(:,:,j)*T;
        To(:,:,i)=Ttemp*T;
        %         Ttemp(:,:,j)=To(:,:,i);
        Ttemp=To(:,:,i);
        %      Qo(1:3,i)=To(1:3,4,i);
    end
    %     R3(:,:,j)= Ttemp(1:3,1:3,j);
    R3(:,:,j)= Ttemp;
    R36(:,:,j)=R3(:,:,j)'*Rzxy;
    
    if R36(1,3,j)==0&&R36(3,3,j)==0
        the5_L(j)=0;
        the5_R(j)=0;
        disp('WE CAN NOT SOLVE THETA4 and THETA6 INDIVIDUALLY' )
        disp('THERE ARE INFINITE POSSIBLE SOLUTIONS')
        %         the7(j)=atan2d(-R36(3,1),R36(1,1));
    else
        %         for i=1:2
        %             if i==1
        the5_L(j)=atan2d(sqrt(1-R36(2,3)^2),R36(2,3));
        the4_L(j)=atan2d(R36(3,3),-R36(1,3));
        the6_L(j)=atan2d(-R36(2,2),R36(2,1));
        %             else
        the5_R(j)=atan2d(-sqrt(1-R36(2,3)^2),R36(2,3));
        the4_R(j)=atan2d(-R36(3,3),R36(1,3));
        the6_R(j)=atan2d(R36(2,2),-R36(2,1));
        %             end
        %         end
    end
end
Sol1=[DH1  the5_L(1) the4_L(1) the6_L(1)]
Sol2=[DH1  the5_R(1) the4_R(1) the6_R(1)]
Sol3=[DH2  the5_L(2) the4_L(2) the6_L(2)]
Sol4=[DH2  the5_R(2) the4_R(2) the6_R(2)]
Sol5=[DH3  the5_L(3) the4_L(3) the6_L(3)]
Sol6=[DH3  the5_R(3) the4_R(3) the6_R(3)]
Sol7=[DH4  the5_L(4) the4_L(4) the6_L(4)]
Sol8=[DH4  the5_R(4) the4_R(4) the6_R(4)]
S=[Sol1;Sol2;Sol3;Sol4;Sol4;Sol5;Sol6;Sol7;Sol8];
% #########################################################
for k=1:8
    Ttem=eye(4);
    %     Ttem(:,:,j)=eye(4);
    for i=1:6
        T=[cosd(S(k,i)) -sind(S(k,i)) 0 a(i);
            sind(S(k,i))*cosd(alp(i)) cosd(S(k,i))*cosd(alp(i)) -sind(alp(i)) -d(i)*sind(alp(i));
            sind(S(k,i))*sind(alp(i)) cosd(S(k,i))*sind(alp(i)) cosd(alp(i)) d(i)*cosd(alp(i));
            0 0 0 1];
        %         Ti(:,:,i)=Ttem(:,:,k)*T;
        %         Ttem(:,:,k)=Ti(:,:,i);
        Ti(:,:,i)=Ttem*T;
        Ttem=Ti(:,:,i);
        Qo(1:3,i,k)=Ti(1:3,4,i);
    end
    pe(:,k)=Qo(:,6,k)+Ti(1:3,1:3,6)*dE;
    x(k,1:7)=[Qo(1,:,k) pe(1,k)];
    y(k,1:7)=[Qo(2,:,k) pe(2,k)];
    z(k,1:7)=[Qo(3,:,k) pe(3,k)];
    %     figure
    subplot(2,4,k)
    plot3(x(k,:),y(k,:),z(k,:),'linewidth',2)
    
    axis([xmin xmax ymin ymax zmin zmax]);
    
end

