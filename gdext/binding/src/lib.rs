use petgraph::graph::UnGraph;

struct Network {
    graph: UnGraph<String, f32>,
}

fn network_new() -> Box<Network> {
    Box::new(Network {
        graph: UnGraph::new_undirected(),
    })
}

impl Network {
    fn add_node(&mut self, name: &str) -> usize {
        self.graph.add_node(name.into()).index()
    }

    fn node_count(&self) -> usize {
        self.graph.node_count()
    }
}

#[cxx::bridge]
mod ffi {
    // Any shared structs, whose fields will be visible to both languages.
    struct BlobMetadata {
        size: usize,
        tags: Vec<String>,
    }

    extern "Rust" {
        // Zero or more opaque types which both languages can pass around
        // but only Rust can see the fields.
        type Network;

        // Functions implemented in Rust.
        fn network_new() -> Box<Network>;
        fn add_node(self: &mut Network, name: &str) -> usize;
        fn node_count(self: &Network) -> usize;
    }
}

pub fn add(left: usize, right: usize) -> usize {
    left + right
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }
}
