use petgraph::prelude::*;

pub struct EdgeInfo {
    name: String,
    lane_count: u16,
    capacity: f32,
    length: f32,
    free_speed: f32,
}

type Graph = StableDiGraph<String, EdgeInfo, u32>;

pub struct ReducedNetwork {
    graph: Graph,
}

impl ReducedNetwork {
    pub fn new() -> Self {
        ReducedNetwork {
            graph: Graph::new()
        }
    }

    pub fn add_node(&mut self, name: &str) -> NodeIndex {
        self.graph.add_node(name.into())
    }

    pub fn remove_node(&mut self, id: NodeIndex) -> Option<String> {
        self.graph.remove_node(id)
    }

    pub fn add_edge(&mut self, id_from: NodeIndex, id_to: NodeIndex, info: EdgeInfo) -> Option<EdgeIndex> {
        (
            self.graph.contains_node(id_from)
            & self.graph.contains_node(id_to)
            & !self.graph.contains_edge(id_from, id_to)
        ).then(|| self.graph.add_edge(id_from, id_to, info))
    }

    pub fn remove_edge(&mut self, e: EdgeIndex) -> Option<EdgeInfo> {
        self.graph.remove_edge(e)
    }
}