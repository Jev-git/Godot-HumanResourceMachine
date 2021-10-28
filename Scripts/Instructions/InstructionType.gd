extends Node

enum INSTRUCTION_TYPE {
	INBOX,			# 0
	OUTBOX,			# 1
	JUMP,			# 2
	JUMP_TARGET,	# 3
	COPY_FROM,		# 4
	COPY_TO,		# 5
	ADD,			# 6
	JUMP_IF_ZERO	# 7
}
