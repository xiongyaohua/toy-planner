#ifndef TNETWORK_CLASS_H
#define TNETWORK_CLASS_H

#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/variant/variant.hpp>
#include <godot_cpp/core/binder_common.hpp>

#include <cxxbridge/binding/src/lib.rs.h>

using namespace godot;

class TNetwork : public RefCounted {
	GDCLASS(TNetwork, RefCounted);

private:
	rust::Box<Network> _network;

protected:
	static void _bind_methods();

public:
	TNetwork() : _network(network_new()) {}
	~TNetwork() {}

    size_t add_node(const String &p_name) { return _network->add_node(p_name.utf8().get_data()); }
    size_t get_node_count() { return _network->node_count(); }
};

#endif  // TNETWORK_CLASS_H