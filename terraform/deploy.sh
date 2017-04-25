if [ -z "$1" ]
then
  echo "Usage: must pass the terraform directory"
  exit 1
fi

export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""

cd $1
terraform $2
