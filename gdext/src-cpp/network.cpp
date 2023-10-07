#include "network.h"

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void TNetwork::_bind_methods() {
	ClassDB::bind_method(D_METHOD("get_node_count"), &TNetwork::get_node_count);
	ClassDB::bind_method(D_METHOD("add_node", "p_name"), &TNetwork::add_node);
}