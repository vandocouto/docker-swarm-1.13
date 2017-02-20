if [ -z "$1" ]
then
  echo "Usage: must pass the terraform directory"
  exit 1
fi

export AWS_ACCESS_KEY_ID="AKIAJPX66JYLXQMTCDKA"
export AWS_SECRET_ACCESS_KEY="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"
export AWS_DEFAULT_REGION="us-west-1"

cd $1
terraform $2
