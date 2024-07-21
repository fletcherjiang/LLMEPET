dset_name=charadesSTA
ctx_mode=video_tef
v_feat_types=slowfast_clip
t_feat_type=clip 
results_root=results_charadesSTA
exp_id=exp

######## data paths
train_path=data/charades_sta/charades_sta_train_tvr_format.jsonl
eval_path=data/charades_sta/charades_sta_test_tvr_format.jsonl
eval_split_name=val

######## setup video+text features
feat_root=features/charades

# video features
v_feat_dim=0
v_feat_dirs=()# video features
v_feat_dim=0
v_feat_dirs=()
if [[ ${v_feat_types} == *"slowfast"* ]]; then
  v_feat_dirs+=(${feat_root}/slowfast_features)
  (( v_feat_dim += 2304 ))  # double brackets for arithmetic op, no need to use ${v_feat_dim}
fi
if [[ ${v_feat_types} == *"clip"* ]]; then
  v_feat_dirs+=(${feat_root}/clip_features)
  (( v_feat_dim += 512 ))
fi

# text features
if [[ ${t_feat_type} == "clip" ]]; then
  t_feat_dir=${feat_root}/clip_text_features/
  t_feat_dim=512
else
  echo "Wrong arg for t_feat_type."
  exit 1
fi

#### training
bsz=32
enc_layers=4
dec_layers=2
t2v_layers=2
clip_length=1
moment_layers=1
dummy_layers=2
sent_layers=1
max_v_l=-1
max_q_l=75
first_layer=14
n_layers=17
event_coef=0.1
pos_coef=0.1


PYTHONPATH=$PYTHONPATH:. python llm_epet/train.py \
--dset_name ${dset_name} \
--ctx_mode ${ctx_mode} \
--clip_length ${clip_length} \
--train_path ${train_path} \
--eval_path ${eval_path} \
--eval_split_name ${eval_split_name} \
--v_feat_dirs ${v_feat_dirs[@]} \
--v_feat_dim ${v_feat_dim} \
--t_feat_dir ${t_feat_dir} \
--t_feat_dim ${t_feat_dim} \
--bsz ${bsz} \
--results_root ${results_root} \
--exp_id ${exp_id} \
--enc_layers ${enc_layers} \
--dec_layers ${dec_layers} \
--t2v_layers ${t2v_layers} \
--moment_layers ${moment_layers} \
--dummy_layers ${dummy_layers} \
--sent_layers ${sent_layers} \
--max_v_l ${max_v_l} \
--max_q_l ${max_q_l} \
--event_coef ${event_coef} \
--pos_coef ${pos_coef} \
--first_layer ${first_layer} \
--n_layers ${n_layers} \
--resume ${resume}  \
${@:1}