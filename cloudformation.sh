#!/usr/bin/env bash -e

cd $(dirname $0)/..

_stack_status() {
	status=$(
		aws cloudformation describe-stacks \
			--stack-name "${STACK_NAME}" \
			--query 'Stacks[]["StackStatus"][]' \
			--output text \
			2>/dev/null
	)
	[[ -z "${status}" ]] && return 1
	echo "${status}"
}

_stack_exists() {
	[[ ! -z "$(_stack_status)" ]]
	return $?
}

_wait_until_complete() {
	[[ $(_stack_status) =~ COMPLETE$ ]] && exit 0
	aws cloudformation wait stack-${ACTION}-complete \
		--stack-name "${STACK_NAME}" \
		&>/dev/null
}

_stack_exists && ACTION="update" || ACTION="create"

if [[ ! $(_stack_status) =~ IN_PROGRESS$ ]]; then
	aws cloudformation ${ACTION}-stack \
		--stack-name ${STACK_NAME} \
		--template-body file://deployment/aws/route53/template_${ENV}.json \
		--region ${AWS_REGION} 2>&1 \
		--output json
fi

echo "Waiting for stack to ${ACTION}"
_wait_until_complete
