function AnswerToCheck=compareELDefaults()
%load data
load('EL_DEFAULTS_original.mat');
EL_DEFAULTS_original=EL_DEFAULTS;
clear EL_DEFAULTS
load('EL_DEFAULTS_LAST_RUN.mat');
EL_DEFAULTS_check=EL_DEFAULTS;
clear EL_DEFAULTS

fields = fieldnames(EL_DEFAULTS_original);
IndSaveTime=find(strcmp({'save_time'},fields));
fields(IndSaveTime)=[];
for ii=1:size(fields,1)
    value_original=EL_DEFAULTS_original.(fields{ii});
    value_check=EL_DEFAULTS_check.(fields{ii});
    class_value=class(value_original);
    switch class_value
        case 'double'
            check_vec(ii)=all(value_original==value_check);
        case 'char'
            check_vec(ii)=strcmp(value_check,value_original);
    end
end


if all(check_vec)
    AnswerToCheck='All The Same';
else
    AnswerToCheck='Something Different';
end
disp(check_vec);
disp(AnswerToCheck);
end