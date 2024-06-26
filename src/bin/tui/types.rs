// Copyright 2020 The MWC Developers
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//! Types specific to the UI module

use std::sync::{Arc, RwLock};

use cursive::view::View;
use cursive::Cursive;
use stats::Stats;

/// Main message struct to communicate between the UI and
/// the main process
pub enum UIMessage {
	/// Update mining status
	UpdateStatus(Arc<RwLock<Stats>>),
}

/// Trait for a UI element that recieves status update messages
/// and updates itself

pub trait TUIStatusListener {
	/// create the view, to return to the main UI controller
	fn create() -> Box<dyn View>;
	/// Update according to status update contents
	fn update(c: &mut Cursive, stats: Arc<RwLock<Stats>>);
}
