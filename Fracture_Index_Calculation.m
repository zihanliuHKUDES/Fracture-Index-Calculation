clear
clc
%-------------------------- input data array -----------------------------%
% - Case 1: Regular spacing
si = [50 50 50 50 50 50 30 30 30 30 30 10 10 10 10 10 10 40 40 40 40 40 15 15 15 15 15 15 15];
% - Case 2: HF included
% si = [50 50 50 50 50 50 30 30 30 30 30 10 10 10 10 10 10 40 5 5 5 5 15 15 15 15 15 15 15];
% - Case 3: Random spacing
% si = [50 45 65 55 40 53 31 35 38 39 28 11 15 10 16 17 14 42 5 4.9 4 1 12 13 14 15 11 13 18];
%-------------------------------------------------------------------------%
%
%                             Exclude HF/NI seg  
%
%-------------------------------------------------------------------------%
sip= si(1:size(si,2)-1);   % -1 delete last one spacing value
cv = 5.0;   % critical value
cn = 3;     % critical number of spacing
n = 0;      % number of small spacing
r = 0;      % rows of continious HF segments
niL = [];
for i=1:size(si,2)
    if(si(i) <= cv & si(i)>0)
        n = n + 1;  % count number of small spacing
        if(i>2)     % indentify NI segment
            if(si(i-2)<0)
                r = r + 1;
                nign = si(i-2:i-1); % i-n-1 add former one fracture
                nig(r,1:size(nign,2)) = nign; % log HF group
                niLn = i-2:i-1;     % i-n-1 add former one fracture
                niL(r,1:size(niLn,2)) = niLn;     % log HF location
            end
        end
    else
        if(n >= cn) % appear HF segments
            r = r + 1;
            if(i-n-1 > 0)
                nign = si(i-n-1:i-1); % i-n-1 add former one fracture
                nig(r,1:size(nign,2)) = nign; % log HF group
                niLn = i-n-1:i-1;     % i-n-1 add former one fracture
                niL(r,1:size(niLn,2)) = niLn;     % log HF location
            else
                nign = si(i-n:i-1); % i-n-1 add former one fracture
                nig(r,1:size(nign,2)) = nign; % log HF group
                niLn = i-n:i-1;     % i-n-1 add former one fracture
                niL(r,1:size(niLn,2)) = niLn;     % log HF location
            end
        end
        n = 0;
        if(i>2)     % indentify NI segment
            if(si(i-2)<0)
                r = r + 1;
                nign = si(i-2:i-1); % i-n-1 add former one fracture
                nig(r,1:size(nign,2)) = nign; % log HF group
                niLn = i-2:i-1;     % i-n-1 add former one fracture
                niL(r,1:size(niLn,2)) = niLn;     % log HF location
            end
        end
    end
end
% sip= si(1:size(si,2));   % -1 delete last one spacing value
for k=1:r   % sum HF group spacing, add to following one spacing
    if(niL(r+1-k,length(find(niL(r+1-k,:)~=0)))+1 <= size(sip,2))
%         si(niL(r+1-k,length(find(niL(r+1-k,:)~=0)))+1) = si(niL(r+1-k,length(find(niL(r+1-k,:)~=0)))+1) + sum(nig(r+1-k,:));
%     else      % in case of last seg are HF seg
        sip(niL(r+1-k,length(find(niL(r+1-k,:)~=0)))+1) = sip(niL(r+1-k,length(find(niL(r+1-k,:)~=0)))+1) + sum(nig(r+1-k,:));
        sipL(1,niL(r+1-k,length(find(niL(r+1-k,:)~=0)))+1) = sip(niL(r+1-k,length(find(niL(r+1-k,:)~=0)))+1);
        sipL(2,niL(r+1-k,length(find(niL(r+1-k,:)~=0)))+1) = niL(r+1-k,length(find(niL(r+1-k,:)~=0)))+1;
    end         % sipL: record the location of fractures that follow a HF segment
    if(k == 1)	% log last seg cut by HF seg
        sii(k,:) = sip((niL(r+1-k,length(find(niL(r+1-k,:)~=0)))+1):end);
        siiL(k,1)= size(sip((niL(r+1-k,length(find(niL(r+1-k,:)~=0)))+1):end),2); % log number
    else        % log middle segs cut by HF seg
        siin = sip((niL(r+1-k,length(find(niL(r+1-k,:)~=0)))+1):(niL(r+1-k+1,1)-1));
        sii(k,1:size(siin,2)) = siin;
        siiL(k,1)= size(siin,2);    % log number
    end
    if(k == r)	% log first seg cut by HF seg
        siin = sip(1:niL(r+1-k,1)-1);
        sii(k+1,1:size(siin,2)) = sip(1:niL(r+1-k,1)-1);
        siiL(k+1,1)= size(siin,2);  % log number
    end
    sip(niL(r+1-k,1:length(find(niL(r+1-k,:)~=0))))=[];   % exclude HF segments
end
n = size(sip,2);      % total number of fractures
for i=1:n
    sxx(i)=sum(sip(1:i)); % record fracture location from zero
end
%--------------------------------------------------------------------------%
%
%                          Formal computation 
%
%--------------------------------------------------------------------------%
figure
%--------------------------------------------------------------------------%
%
%                            No HF segments 
%
%--------------------------------------------------------------------------%
if(isempty(niL))
    minG = 3;   % minimum group member
    p1 = 100; p2 = 100; p3 = 100; p4 = 100; p5 = 100; 
    pp = 0;
    s=sip;
    %--------------------------- one groups ------------------------------%
    q = 1;                  % total group number
    if(n >= q*minG)
        m = 1;              % initialize total group scheme
        s1=s(1:n)           % first group
        data1(m,q) = var(s1(2:end));	% sum up Standard Deviation of each group
        p1=min(data1(:,q));	% find the minimum total Standard Deviation
        pp = pp + 1;
    end
    %--------------------------- two groups ------------------------------%
    q = 2;              % total group number
    data2 = 0;          % initialize matrix
    if(n >= q*minG)
        m = 1;              % initialize total group scheme
        for i=minG:(n-minG*(q-1))
            s1=s(1:i);  % first group
            s2=s(i+1:n);    % last group
            data2(m,1:q-1)=[i];    % record group scheme
            % sum up Standard Deviation of each group
            data2(m,q) = var(s1(2:end))+var(s2(2:end)); 
            m=m+1;  % count up total group scheme
        end
        p2=min(data2(:,q));   % find the minimum total Standard Deviation
        pp = pp + 1;
        [y,z]=find(data2==p2);% find its corresponding group scheme
        s1=s(1:data2(y,1))          % optimal first group
        s2=s(data2(y,1)+1:n)        % optimal second group
    end
    %--------------------------- three groups ------------------------------%
    q = 3;              % total group number
    data3 = 0;          % initialize matrix
    if(n >= q*minG)
        m=1;            % initialize total group scheme
        for i=minG:(n-minG*(q-1))
            s1=s(1:i);  % first group
            for k=i+minG:(n-minG*(q-2))
                s2=s(i+1:k);    % third group
                s3=s(k+1:n);    % last group
                data3(m,1:q-1)=[i k];    % record group scheme
                % sum up Standard Deviation of each group
                data3(m,q) = var(s1(2:end))+var(s2(2:end))+var(s3(2:end)); 
                m=m+1;  % count up total group scheme
            end
        end
        p3=min(data3(:,q));   % find the minimum total Standard Deviation
        pp = pp + 1;
        [y,z]=find(data3==p3);% find its corresponding group scheme
        s1=s(1:data3(y,1))              % optimal first group
        s2=s(data3(y,1)+1:data3(y,2))   % optimal second group
        s3=s(data3(y,2)+1:n)            % optimal last group
    end
    %-------------------------- four groups ------------------------------%
    q=4;            % total group
    data4 = 0;      % initialize matrix
    if(n >= q*minG)
        m=1;        % initialize total group scheme
        for i=minG:(n-minG*(q-1))
            s1=s(1:i);  % first group
            for j=i+minG:(n-minG*(q-2))
                s2=s(i+1:j);    % second group
                for k=j+minG:(n-minG*(q-3))
                    s3=s(j+1:k);    % third group
                    s4=s(k+1:n);    % last group
                    data4(m,1:q-1)=[i j k];    % record group scheme
                    % sum up Standard Deviation of each group
                    data4(m,4) = var(s1(2:end))+var(s2(2:end))+var(s3(2:end))+var(s4(2:end)); 
                    m=m+1;  % count up total group scheme
                end
            end
        end
        p4=min(data4(:,4));   % find the minimum total Standard Deviation
        pp = pp + 1;
        [y,z]=find(data4==p4);% find its corresponding group scheme
        s1=s(1:data4(y,1))              % optimal first group
        s2=s(data4(y,1)+1:data4(y,2))   % optimal second group
        s3=s(data4(y,2)+1:data4(y,3))   % optimal third group
        s4=s(data4(y,3)+1:n)            % optimal last group
    end
    %------------------------- five groups ------------------------------%
    q=5;        % total group
    data5 = 0;  % initialize matrix
    if(n >= q*minG)
        o=1;    % initialize total group scheme
        for i=minG:(n-minG*(q-1))
            s1=s(1:i);  % first group
            for j=i+minG:(n-minG*(q-2))
                s2=s(i+1:j);    % second group
                for k=j+minG:(n-minG*(q-3))
                    s3=s(j+1:k);    % third group
                    for l=k+minG:(n-minG*(q-4))
                        s4=s(k+1:l);    % fourth group
                        s5=s(l+1:n);    % last group
                        data5(o,1:q-1)=[i j k l];    % record group scheme
                        % sum up Standard Deviation of each group
                        data5(o,5) = var(s1(2:end))+var(s2(2:end))+var(s3(2:end))+var(s4(2:end))+var(s5(2:end)); 
                        o=o+1;  % count up total group scheme
                    end
                end
            end
        end
        p5=min(data5(:,5));     % find the minimum total Standard Deviation
        pp = pp + 1;
        [y,z]=find(data5==p5);	% find its corresponding group scheme
        s1=s(1:data5(y,1))              % optimal first group
        s2=s(data5(y,1)+1:data5(y,2))   % optimal second group
        s3=s(data5(y,2)+1:data5(y,3))   % optimal third group
        s4=s(data5(y,3)+1:data5(y,4))	% optimal last group
        s5=s(data5(y,4)+1:n)            % optimal last group
    end
    %---------------------------------------------------------------------%
    %
    %                        output groups
    %
    %---------------------------------------------------------------------%
    h = 0;
    if(pp > 0)
        [g,h]=min([p1,p2,p3,p4,p5]);
    end
    
    if((n < 1*minG) || (h==1))
%         if(size(sx,2) > 0)  % for only HF, no one fracture part 
            s1=s;
            stem(sxx(1:end),ones(size(s1)),'LineWidth',2,'Marker','none'); hold on;
            fiLFL = (find(si(:) == s1(end)));    % Last number location of s1 in s
%             if(isempty(fiLFL))
%                 fiLFL = (find(round(si(:),4) == round(s1(1) - sum(nig(w-1,:)),4)));    % Last number location of s1 in s
%             end
            fi1=size(s1,2)/(sum(s1)*0.01) % add half later spacing            
%             fi1=size(s1,2)/((sum(s1)+si(fiLFL+1)*0.5)*0.01) % add half later spacing
            xlim([0 s1(size(s1,2))+50]);
            text((sxx(1)+sxx(end))/2-5,-0.07,num2str(round(fi1,1)),'color','r','FontSize',13)
            set(gcf,'Position',[100 100 950 120]);
            stem(sum(si),ones(1),'LineWidth',2,'color','k','Marker','none');
%         end
    end
    if(h==2)    % h is the column of min([p3,p4,p5])
        [y,z]=find(data2==p2);% find its corresponding group scheme
        s1=s(1:data2(y,1))              % optimal first group
        s2=s(data2(y,1)+1:n)   % optimal second group
            %------------------ re-arrange  ------------------%
            % If the spacing of the last fracture is greater than the mean 
            % value of the latter group, the fracture is assigned to the latter group
            if(s1(size(s1,2))>2*mean(s2))
                data2(y,1)=data2(y,1)-1;
            end
            s1=s(1:data2(y,1))      % optimal first group
            s2=s(data2(y,1)+1:n)    % optimal second group
            %-------------------------------------------------%
%         figure
        stem(sxx(1:data2(y,1)),ones(size(s1)),'LineWidth',2,'Marker','none'); hold on;
        stem(sxx(data2(y,1)+1:n),ones(size(s2)),'LineWidth',2,'Marker','none'); 
        fi1=size(s1,2)/((sum(s1)+s2(1)/2)*0.01)
        fi2=size(s2,2)/((sum(s2)-s2(1)/2)*0.01)
        xlim([0 sxx(size(sxx,2))+50]);
        set(gcf,'Position',[100 100 950 120]);
        stem(sum(si),ones(1),'LineWidth',2,'color','k','Marker','none');
        text((sxx(1)+sxx(data2(y,1)))/2-5,-0.07,num2str(round(fi1,1)),'color','r','FontSize',13)
        text((sxx(data2(y,1))+sxx(end))/2-5,-0.07,num2str(round(fi2,1)),'color','r','FontSize',13)
    end
    if(h==3)
        [y,z]=find(data3==p3);% find its corresponding group scheme
        s1=s(1:data3(y,1))              % optimal first group
        s2=s(data3(y,1)+1:data3(y,2))   % optimal second group
        s3=s(data3(y,2)+1:n)            % optimal last group
            %------------------ re-arrange  ------------------%
            % If the spacing of the last fracture is greater than the mean 
            % value of the latter group, the fracture is assigned to the latter group
            if(s1(size(s1,2))>2*mean(s2))
                data3(y,1)=data3(y,1)-1;
            end
            if(s2(size(s2,2))>2*mean(s3))
                data3(y,2)=data3(y,2)-1;
            end
            s1=s(1:data3(y,1))              % optimal first group
            s2=s(data3(y,1)+1:data3(y,2))   % optimal second group
            s3=s(data3(y,2)+1:n)            % optimal last group
            %-------------------------------------------------%
%         figure
        stem(sxx(1:data3(y,1)),ones(size(s1)),'LineWidth',2,'Marker','none'); hold on;
        stem(sxx(data3(y,1)+1:data3(y,2)),ones(size(s2)),'LineWidth',2,'Marker','none'); 
        stem(sxx(data3(y,2)+1:n),ones(size(s3)),'LineWidth',2,'Marker','none');
        fi1=size(s1,2)/((sum(s1)+s2(1)/2)*0.01)
        fi2=size(s2,2)/((sum(s2)-s2(1)/2+s3(1)/2)*0.01)
        fi3=size(s3,2)/((sum(s3)-s3(1)/2)*0.01)
        xlim([0 sxx(size(sxx,2))+50]);
        set(gcf,'Position',[100 100 950 120]);
        stem(sum(si),ones(1),'LineWidth',2,'color','k','Marker','none');
        text((sxx(1)+sxx(data3(y,1)))/2-5,-0.07,num2str(round(fi1,1)),'color','r','FontSize',13)
        text((sxx(data3(y,1))+sxx(data3(y,2)))/2-5,-0.07,num2str(round(fi2,1)),'color','r','FontSize',13)
        text((sxx(data3(y,2))+sxx(end))/2-5,-0.07,num2str(round(fi2,1)),'color','r','FontSize',13)
    end
    if(h==4)
        [y,z]=find(data4==p4);% find its corresponding group scheme
        s1=s(1:data4(y,1))          % optimal first group
        s2=s(data4(y,1)+1:data4(y,2)) % optimal second group
        s3=s(data4(y,2)+1:data4(y,3)) % optimal third group
        s4=s(data4(y,3)+1:n)         % optimal last group
            %------------------ re-arrange  ------------------%
            % If the spacing of the last fracture is greater than the mean 
            % value of the latter group, the fracture is assigned to the latter group
            if(s1(size(s1,2))>2*mean(s2))
                data4(y,1)=data4(y,1)-1;
            end
            if(s2(size(s2,2))>2*mean(s3))
                data4(y,2)=data4(y,2)-1;
            end
            if(s3(size(s3,2))>2*mean(s4))
                data4(y,3)=data4(y,3)-1;
            end
            s1=s(1:data4(y,1))           % optimal first group
            s2=s(data4(y,1)+1:data4(y,2)) % optimal second group
            s3=s(data4(y,2)+1:data4(y,3)) % optimal third group
            s4=s(data4(y,3)+1:n)         % optimal last group
            %-------------------------------------------------%
%         figure
        stem(sxx(1:data4(y,1)),ones(size(s1)),'LineWidth',2,'Marker','none'); hold on;
        stem(sxx(data4(y,1)+1:data4(y,2)),ones(size(s2)),'LineWidth',2,'Marker','none'); 
        stem(sxx(data4(y,2)+1:data4(y,3)),ones(size(s3)),'LineWidth',2,'Marker','none'); 
        stem(sxx(data4(y,3)+1:n),ones(size(s4)),'LineWidth',2,'Marker','none');
        fi1=size(s1,2)/((sum(s1)+s2(1)/2)*0.01)
        fi2=size(s2,2)/((sum(s2)-s2(1)/2+s3(1)/2)*0.01)
        fi3=size(s3,2)/((sum(s3)-s3(1)/2+s4(1)/2)*0.01)
        fi4=size(s4,2)/((sum(s4)-s4(1)/2)*0.01)
        xlim([0 sxx(size(sxx,2))+50]);
        set(gcf,'Position',[100 100 950 120]);
        stem(sum(si),ones(1),'LineWidth',2,'color','k','Marker','none');
        text((sxx(1)+sxx(data4(y,1)))/2-5,-0.07,num2str(round(fi1,1)),'color','r','FontSize',13)
        text((sxx(data4(y,1))+sxx(data4(y,2)))/2-5,-0.07,num2str(round(fi2,1)),'color','r','FontSize',13)
        text((sxx(data4(y,2))+sxx(data4(y,3)))/2-5,-0.07,num2str(round(fi3,1)),'color','r','FontSize',13)
        text((sxx(data4(y,3))+sxx(end))/2-5,-0.07,num2str(round(fi4,1)),'color','r','FontSize',13)
    end
    if(h==5)
        [y,z]=find(data5==p5);	% find its corresponding group scheme
        if(size(y,1)>1)           
            y(1)=max(y);
            y(2:size(y))=[];        
        end
        s1=s(1:data5(y,1))              % optimal first group
        s2=s(data5(y,1)+1:data5(y,2))   % optimal second group
        s3=s(data5(y,2)+1:data5(y,3))   % optimal third group
        s4=s(data5(y,3)+1:data5(y,4))	% optimal fourth group
        s5=s(data5(y,4)+1:n)            % optimal last group
            %------------------ re-arrange  ------------------%
            % If the spacing of the last fracture is greater than the mean 
            % value of the latter group, the fracture is assigned to the latter group
            if(s1(size(s1,2))>1.5*mean(s2))
                data5(y,1)=data5(y,1)-1;
            end
            if(s2(size(s2,2))>1.5*mean(s3))
                data5(y,2)=data5(y,2)-1;
            end
            if(s3(size(s3,2))>1.5*mean(s4))
                data5(y,3)=data5(y,3)-1;
            end
            if(s4(size(s4,2))>1.5*mean(s5))
                data5(y,4)=data5(y,4)-1;
            end
            s1=s(1:data5(y,1))              % optimal first group
            s2=s(data5(y,1)+1:data5(y,2))   % optimal second group
            s3=s(data5(y,2)+1:data5(y,3))   % optimal third group
            s4=s(data5(y,3)+1:data5(y,4))	  % optimal fourth group
            s5=s(data5(y,4)+1:n)            % optimal last group
            %-------------------------------------------------%
%         figure
        stem(sxx(1:data5(y,1)),ones(size(s1)),'LineWidth',2,'Marker','none'); hold on;
        stem(sxx(data5(y,1)+1:data5(y,2)),ones(size(s2)),'LineWidth',2,'Marker','none'); 
        stem(sxx(data5(y,2)+1:data5(y,3)),ones(size(s3)),'LineWidth',2,'Marker','none'); 
        stem(sxx(data5(y,3)+1:data5(y,4)),ones(size(s4)),'LineWidth',2,'Marker','none'); 
        stem(sxx(data5(y,4)+1:n),ones(size(s5)),'LineWidth',2,'Marker','none');
        fi1=size(s1,2)/((sum(s1)+s2(1)/2)*0.01)
        fi2=size(s2,2)/((sum(s2)-s2(1)/2+s3(1)/2)*0.01)
        fi3=size(s3,2)/((sum(s3)-s3(1)/2+s4(1)/2)*0.01)
        fi4=size(s4,2)/((sum(s4)-s4(1)/2+s5(1)/2)*0.01)
        fi5=size(s5,2)/((sum(s5)-s5(1)/2)*0.01)
        xlim([0 sxx(size(sxx,2))+50]);
        set(gcf,'Position',[100 100 950 120]);
        stem(sum(si),ones(1),'LineWidth',2,'color','k','Marker','none');
        text((sxx(1)+sxx(data5(y,1)))/2-5,-0.07,num2str(round(fi1,1)),'color','r','FontSize',13)
        text((sxx(data5(y,1))+sxx(data5(y,2)))/2-5,-0.07,num2str(round(fi2,1)),'color','r','FontSize',13)
        text((sxx(data5(y,2))+sxx(data5(y,3)))/2-5,-0.07,num2str(round(fi3,1)),'color','r','FontSize',13)
        text((sxx(data5(y,3))+sxx(data5(y,4)))/2-5,-0.07,num2str(round(fi4,1)),'color','r','FontSize',13)
        text((sxx(data5(y,4))+sxx(end))/2-5,-0.07,num2str(round(fi5,1)),'color','r','FontSize',13)
    end
end
stem(sum(si),ones(1),'LineWidth',2,'color','k','Marker','none','Marker','none'); % draw the end of the core
xlim([0 sum(si)+50]); % for some special cases
set(gca,'YTick',[]);  % no Y axis
set(gca,'xaxislocation','top');
% set(gca,'XTickLabel','FontSize',20);
% ax.FontSize = 15;
if(isempty(niL))
    return  % no HF segs, over
end
%
%--------------------------------------------------------------------------%
%
%                          Including HF segments 
%
%--------------------------------------------------------------------------%
for w=1:r+1
    si1 = sii(r+2-w,1:siiL(r+2-w,1));
    si2 = sip(2:size(sip,2));     
    %--------------------------- choose scheme ------------------------------%
    s = si1;            % 
    minG = 3;           % minimum group member
    p1=1000; p2 = 1000; p3 = 1000; p4 = 1000; p5 = 1000; 
    pp = 0;
    %------------------------ record fracture location ----------------------%
    n = size(s,2);      % total number of fractures
    if(w==1)
        sx = sxx(1:siiL(r+2-w,1));
    else if(w==r+1)
            sx = sxx(sum(siiL(r+2-w+1:end,1))+1:end);
        else
            sx = sxx(sum(siiL(r+2-w+1:end,1))+1:sum(siiL(r+2-w+1:end,1))+siiL(r+2-w,1));
        end
    end
    %--------------------------- one groups ------------------------------%
    q = 1;                  % total group number
    if(n >= q*minG)
        m = 1;              % initialize total group scheme
        s1=s(1:n)           % first group
        data1(m,q) = var(s1(2:end));	% sum up Standard Deviation of each group
        p1=min(data1(:,q));	% find the minimum total Standard Deviation
        pp = pp + 1;
    end
    %--------------------------- two groups ------------------------------%
    q = 2;              % total group number
    data2 = 0;          % initialize matrix
    if(n >= q*minG)
        m = 1;              % initialize total group scheme
        for i=minG:(n-minG*(q-1))
            s1=s(1:i);  % first group
            s2=s(i+1:n);    % last group
            data2(m,1:q-1)=[i];    % record group scheme
            % sum up Standard Deviation of each group
            data2(m,q) = var(s1(2:end))+var(s2(2:end)); 
            m=m+1;  % count up total group scheme
        end
        p2=min(data2(:,q));   % find the minimum total Standard Deviation
        pp = pp + 1;
        [y,z]=find(data2==p2);% find its corresponding group scheme
        s1=s(1:data2(y,1))          % optimal first group
        s2=s(data2(y,1)+1:n)        % optimal second group
    end
    %--------------------------- three groups ------------------------------%
    q = 3;              % total group number
    data3 = 0;          % initialize matrix
    if(n >= q*minG)
        m=1;            % initialize total group scheme
        for i=minG:(n-minG*(q-1))
            s1=s(1:i);  % first group
            for k=i+minG:(n-minG*(q-2))
                s2=s(i+1:k);    % third group
                s3=s(k+1:n);    % last group
                data3(m,1:q-1)=[i k];    % record group scheme
                % sum up variances of each group 
                % sum up Standard Deviation of each group
                data3(m,q) = var(s1(2:end))+var(s2(2:end))+var(s3(2:end)); 
                m=m+1;  % count up total group scheme
            end
        end
        p3=min(data3(:,q));   % find the minimum total Standard Deviation
        pp = pp + 1;
        [y,z]=find(data3==p3);% find its corresponding group scheme
        s1=s(1:data3(y,1))           % optimal first group
        s2=s(data3(y,1)+1:data3(y,2)) % optimal second group
        s3=s(data3(y,2)+1:n)         % optimal last group
    end
    %-------------------------- four groups ------------------------------%
    q=4;                % total group
    data4 = 0;          % initialize matrix
    if(n >= q*minG)
        m=1;            % initialize total group scheme
        for i=minG:(n-minG*(q-1))
            s1=s(1:i);  % first group
            for j=i+minG:(n-minG*(q-2))
                s2=s(i+1:j);    % second group
                for k=j+minG:(n-minG*(q-3))
                    s3=s(j+1:k);    % third group
                    s4=s(k+1:n);    % last group
                    data4(m,1:q-1)=[i j k];    % record group scheme
                    % sum up Standard Deviation of each group
                    data4(m,4) = var(s1(2:end))+var(s2(2:end))+var(s3(2:end))+var(s4(2:end)); 
                    m=m+1;  % count up total group scheme
                end
            end
        end
        p4=min(data4(:,4));   % find the minimum total Standard Deviation
        pp = pp + 1;
        [y,z]=find(data4==p4);% find its corresponding group scheme
        s1=s(1:data4(y,1))              % optimal first group
        s2=s(data4(y,1)+1:data4(y,2))   % optimal second group
        s3=s(data4(y,2)+1:data4(y,3))   % optimal third group
        s4=s(data4(y,3)+1:n)            % optimal last group
    end
    %------------------------- five groups ------------------------------%
    q=5;    % total group
    data5 = 0;          % initialize matrix
    if(n >= q*minG)
        o=1;    % initialize total group scheme
        for i=minG:(n-minG*(q-1))
            s1=s(1:i);  % first group
            for j=i+minG:(n-minG*(q-2))
                s2=s(i+1:j);    % second group
                for k=j+minG:(n-minG*(q-3))
                    s3=s(j+1:k);    % third group
                    for l=k+minG:(n-minG*(q-4))
                        s4=s(k+1:l);    % fourth group
                        s5=s(l+1:n);    % last group
                        data5(o,1:q-1)=[i j k l];    % record group scheme
                        % sum up Standard Deviation of each group
                        data5(o,5) = var(s1(2:end))+var(s2(2:end))+var(s3(2:end))+var(s4(2:end))+var(s5(2:end)); 
                        o=o+1;  % count up total group scheme
                    end
                end
            end
        end
        p5=min(data5(:,5));     % find the minimum total Standard Deviation
        pp = pp + 1;
        [y,z]=find(data5==p5);	% find its corresponding group scheme
        s1=s(1:data5(y,1))              % optimal first group
        s2=s(data5(y,1)+1:data5(y,2))   % optimal second group
        s3=s(data5(y,2)+1:data5(y,3))   % optimal third group
        s4=s(data5(y,3)+1:data5(y,4))	% optimal last group
        s5=s(data5(y,4)+1:n)            % optimal last group
    end
    %---------------------------------------------------------------------%
    %
    %                        output groups
    %
    %---------------------------------------------------------------------%
    h = 0;
    if(pp > 0)
        [g,h]=min([p1,p2,p3,p4,p5]);
    end
    
    if((n < 2*minG) || (h==1))
        if(size(sx,2) > 0)  % for only HF, no one fracture part 
            s1=s;
            stem(sx(1:end),ones(size(s1)),'LineWidth',2,'Marker','none'); hold on;
            fiLFL = (find(si(:) == s1(end)));    % Last number location of s1 in s
%             if(isempty(fiLFL))
%                 fiLFL = (find(round(si(:),4) == round(s1(1) - sum(nig(w-1,:)),4)));    % Last number location of s1 in s
%             end
            fi1=size(s1,2)/(sum(s1)*0.01) % add half later spacing
            if(w>1) % First crack after NI/HF, special treatment required for FI calculation
                loc = find(s1(1)==sipL(1,:));
                range = loc - 1 + size(s1,2);
                lengt = (sum(si(loc:range)) + abs(si(range+1)/2.0))*0.01;
                fi1=size(s1,2)/lengt
            end
            xlim([0 sx(size(sx,2))+50]);
            text((sx(1)+sx(end))/2-5,-0.07,num2str(round(fi1,1)),'color','r','FontSize',13)
            set(gcf,'Position',[100 100 950 120]);
            stem(sum(abs(si)),ones(1),'LineWidth',2,'color','k','Marker','none');
        end
    end
    if(h==2)    % h is the column of min([p3,p4,p5])
        [y,z]=find(data2==p2);% find its corresponding group scheme
        s1=s(1:data2(y,1))              % optimal first group
        s2=s(data2(y,1)+1:n)   % optimal second group
            %------------------ re-arrange  ------------------%
            % If the spacing of the last fracture is greater than the mean 
            % value of the latter group, the fracture is assigned to the latter group
            if(s1(size(s1,2))>2*mean(s2))
                data2(y,1)=data2(y,1)-1;
            end
            s1=s(1:data2(y,1))      % optimal first group
            s2=s(data2(y,1)+1:n)    % optimal second group
            %-------------------------------------------------%
%         figure
        stem(sx(1:data2(y,1)),ones(size(s1)),'LineWidth',2,'Marker','none'); hold on;
        stem(sx(data2(y,1)+1:n),ones(size(s2)),'LineWidth',2,'Marker','none'); 
        fi1=size(s1,2)/((sum(s1)+s2(1)/2)*0.01)
        fi2=size(s2,2)/((sum(s2)-s2(1)/2)*0.01)
        xlim([0 sx(size(sx,2))+50]);
        set(gcf,'Position',[100 100 950 120]);
        stem(sum(si),ones(1),'LineWidth',2,'color','k','Marker','none');
        text((sx(1)+sx(data2(y,1)))/2-5,-0.07,num2str(round(fi1,1)),'color','r','FontSize',13)
        text((sx(data2(y,1))+sx(end))/2-5,-0.07,num2str(round(fi2,1)),'color','r','FontSize',13)
    end
    if(h==3)
        [y,z]=find(data3==p3);% find its corresponding group scheme
        if(size(y,1)>1)
           y(2:size(y))=[]; 
        end
        s1=s(1:data3(y,1))              % optimal first group
        s2=s(data3(y,1)+1:data3(y,2))   % optimal second group
        s3=s(data3(y,2)+1:n)            % optimal last group
            %------------------ re-arrange  ------------------%
            % If the spacing of the last fracture is greater than the mean 
            % value of the latter group, the fracture is assigned to the latter group
            if(s1(size(s1,2))>3*mean(s2))
                data3(y,1)=data3(y,1)-1;
            end
            if(s2(size(s2,2))>3*mean(s3))
                data3(y,2)=data3(y,2)-1;
            end
            s1=s(1:data3(y,1))              % optimal first group
            s2=s(data3(y,1)+1:data3(y,2))   % optimal second group
            s3=s(data3(y,2)+1:n)            % optimal last group
            %-------------------------------------------------%
%         figure
        stem(sx(1:data3(y,1)),ones(size(s1)),'LineWidth',2,'Marker','none'); hold on;
        stem(sx(data3(y,1)+1:data3(y,2)),ones(size(s2)),'LineWidth',2,'Marker','none'); 
        stem(sx(data3(y,2)+1:n),ones(size(s3)),'LineWidth',2,'Marker','none');
        fi1=size(s1,2)/((sum(s1)+s2(1)/2)*0.01)
        fi2=size(s2,2)/((sum(s2)-s2(1)/2+s3(1)/2)*0.01)
        fi3=size(s3,2)/((sum(s3)-s3(1)/2)*0.01)
        xlim([0 sx(size(sx,2))+50]);
        set(gcf,'Position',[100 100 950 120]);
        stem(sum(si),ones(1),'LineWidth',2,'color','k','Marker','none');
        text((sx(1)+sx(data3(y,1)))/2-5,-0.07,num2str(round(fi1,1)),'color','r','FontSize',13)
        text((sx(data3(y,1))+sx(data3(y,2)))/2-5,-0.07,num2str(round(fi2,1)),'color','r','FontSize',13)
        text((sx(data3(y,2))+sx(end))/2-5,-0.07,num2str(round(fi3,1)),'color','r','FontSize',13)
    end
    if(h==4)
        [y,z]=find(data4==p4);% find its corresponding group scheme
        s1=s(1:data4(y,1))           % optimal first group
        s2=s(data4(y,1)+1:data4(y,2)) % optimal second group
        s3=s(data4(y,2)+1:data4(y,3)) % optimal third group
        s4=s(data4(y,3)+1:n)         % optimal last group
            %------------------ re-arrange  ------------------%
            % If the spacing of the last fracture is greater than the mean 
            % value of the latter group, the fracture is assigned to the latter group
            if(s1(size(s1,2))>2*mean(s2))
                data4(y,1)=data4(y,1)-1;
            end
            if(s2(size(s2,2))>2*mean(s3))
                data4(y,2)=data4(y,2)-1;
            end
            if(s3(size(s3,2))>2*mean(s4))
                data4(y,3)=data4(y,3)-1;
            end
            s1=s(1:data4(y,1))           % optimal first group
            s2=s(data4(y,1)+1:data4(y,2)) % optimal second group
            s3=s(data4(y,2)+1:data4(y,3)) % optimal third group
            s4=s(data4(y,3)+1:n)         % optimal last group
            %-------------------------------------------------%
%         figure
        stem(sx(1:data4(y,1)),ones(size(s1)),'LineWidth',2,'Marker','none'); hold on;
        stem(sx(data4(y,1)+1:data4(y,2)),ones(size(s2)),'LineWidth',2,'Marker','none'); 
        stem(sx(data4(y,2)+1:data4(y,3)),ones(size(s3)),'LineWidth',2,'Marker','none'); 
        stem(sx(data4(y,3)+1:n),ones(size(s4)),'LineWidth',2,'Marker','none');
        fi1=size(s1,2)/((sum(s1)+s2(1)/2)*0.01)
        fi2=size(s2,2)/((sum(s2)-s2(1)/2+s3(1)/2)*0.01)
        fi3=size(s3,2)/((sum(s3)-s3(1)/2+s4(1)/2)*0.01)
        fi4=size(s4,2)/((sum(s4)-s4(1)/2)*0.01)
        xlim([0 sx(size(sx,2))+50]);
        set(gcf,'Position',[100 100 950 120]);
        stem(sum(si),ones(1),'LineWidth',2,'color','k','Marker','none');
        text((sx(1)+sx(data4(y,1)))/2-5,-0.07,num2str(round(fi1,1)),'color','r','FontSize',13)
        text((sx(data4(y,1))+sx(data4(y,2)))/2-5,-0.07,num2str(round(fi2,1)),'color','r','FontSize',13)
        text((sx(data4(y,2))+sx(data4(y,3)))/2-5,-0.07,num2str(round(fi2,1)),'color','r','FontSize',13)
        text((sx(data4(y,3))+sx(end))/2-5,-0.07,num2str(round(fi2,1)),'color','r','FontSize',13)
    end
    if(h==5)
        [y,z]=find(data5==p5);	% find its corresponding group scheme
        s1=s(1:data5(y,1))              % optimal first group
        s2=s(data5(y,1)+1:data5(y,2))   % optimal second group
        s3=s(data5(y,2)+1:data5(y,3))   % optimal third group
        s4=s(data5(y,3)+1:data5(y,4))	% optimal fourth group
        s5=s(data5(y,4)+1:n)            % optimal last group
            %------------------ re-arrange  ------------------%
            % If the spacing of the last fracture is greater than the mean 
            % value of the latter group, the fracture is assigned to the latter group
            if(s1(size(s1,2))>2*mean(s2))
                data5(y,1)=data5(y,1)-1;
            end
            if(s2(size(s2,2))>2*mean(s3))
                data5(y,2)=data5(y,2)-1;
            end
            if(s3(size(s3,2))>2*mean(s4))
                data5(y,3)=data5(y,3)-1;
            end
            if(s4(size(s4,2))>2*mean(s5))
                data5(y,4)=data5(y,4)-1;
            end
            s1=s(1:data5(y,1))              % optimal first group
            s2=s(data5(y,1)+1:data5(y,2))   % optimal second group
            s3=s(data5(y,2)+1:data5(y,3))   % optimal third group
            s4=s(data5(y,3)+1:data5(y,4))	% optimal fourth group
            s5=s(data5(y,4)+1:n)            % optimal last group
            %-------------------------------------------------%
%         figure
        stem(sx(1:data5(y,1)),ones(size(s1)),'LineWidth',2,'Marker','none'); hold on;
        stem(sx(data5(y,1)+1:data5(y,2)),ones(size(s2)),'LineWidth',2,'Marker','none'); 
        stem(sx(data5(y,2)+1:data5(y,3)),ones(size(s3)),'LineWidth',2,'Marker','none'); 
        stem(sx(data5(y,3)+1:data5(y,4)),ones(size(s4)),'LineWidth',2,'Marker','none'); 
        stem(sx(data5(y,4)+1:n),ones(size(s5)),'LineWidth',2,'Marker','none');
        fi1=size(s1,2)/((sum(s1)+s2(1)/2)*0.01)
        fi2=size(s2,2)/((sum(s2)-s2(1)/2+s3(1)/2)*0.01)
        fi3=size(s3,2)/((sum(s3)-s3(1)/2+s4(1)/2)*0.01)
        fi4=size(s4,2)/((sum(s4)-s4(1)/2+s5(1)/2)*0.01)
        fi5=size(s5,2)/((sum(s5)-s5(1)/2)*0.01)
        xlim([0 sx(size(sx,2))+50]);
        set(gcf,'Position',[100 100 950 120]);
        stem(sum(si),ones(1),'LineWidth',2,'color','k','Marker','none');
        text((sx(1)+sx(data4(y,1)))/2-5,-0.07,num2str(round(fi1,1)),'color','r','FontSize',13)
        text((sx(data4(y,1))+sx(data4(y,2)))/2-5,-0.07,num2str(round(fi2,1)),'color','r','FontSize',13)
        text((sx(data4(y,2))+sx(data4(y,3)))/2-5,-0.07,num2str(round(fi2,1)),'color','r','FontSize',13)
        text((sx(data4(y,3))+sx(data4(y,4)))/2-5,-0.07,num2str(round(fi2,1)),'color','r','FontSize',13)
        text((sx(data4(y,4))+sx(end))/2-5,-0.07,num2str(round(fi2,1)),'color','r','FontSize',13)
    end
end
%--------------------------- Plot HF segments  ---------------------------%
for k=1:r
    x1=sum(abs(si(1:niL(k,1))));
    x2=sum(abs(si(1:niL(k,length(find(niL(k,:)~=0))))));
    x = [x1 x2 x2 x1];
    b = [0  0  1  1 ];
    patch(x,b,'black')
    txt = 'HF';
    text((x1+x2)/2-11,0.5,txt,'color','g','FontSize',13)
end
txt = '(cm)';
    text(4.5,1.12,txt,'color','k','FontSize',10)
stem(sum(abs(si)),ones(1),'LineWidth',2,'color','k','Marker','none','Marker','none'); % draw the end of the core
% xlim([0 sum(si)+50]); % for some special cases
set(gca,'YTick',[]);  % no Y axis
set(gca,'xaxislocation','top');
% set(get(gca, 'Xlabel'),'Fontsize',20);
