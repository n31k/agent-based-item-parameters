# Agent Based Item Parameters

This is a minimal example showing how to obtain item parameters for novel items using a multiagent cognitive simulation.

You have to install a Lisp editor and download the ACT-UP library.

## Knowledge Base

The knowledge base was automatically created by means of scraping (https://www.hp-lexicon.org/)[https://www.hp-lexicon.org/]. The particular topic was elected because it features a rich ontology, only part of which is captured by the specific scraping script.

More specifically: The knowledge base contains relationships of the type $(Object_1, Object2, RelationType)$ and only two types of relations were extracted:

- A __Person__ _has been_ to a __Place__.

- A __Place__ _is in_ another __Place__.

Of course Persons and Places are fictional, except some places exist in actual reality.

> The scraping script is not the focus of this repo. This work deals with how artificial agents learn the ontology by exposure, and how they retrieve and combine information to respond to mastery test questions.

## Simulation of Individual Differences

Agents differ between each other. A beta distribution was used to reflect that few people have expert knowledge of the field, whereas all the rest have less and less knowedge of it. Ideally, the distribution parameters should be fine-tuned by empirical research.

## Fact Frequencies

Fact frequencies also resulted from scraping. The script kept log of how often a relation occured, and in which book. (In a variation I estimated parameters of beta distributions capturing what the frequencies of such data look like in the real world; and used similar distributions to assign frequencies to facts arbitrarily, which obviously would compromise the original frequencies of any specific fact. That is, rare facts could be depicted as boringly common all the same.)

## Result

The model results to a matrix of agent responses to test questions, in the form of 0-1, zero for wrong, one for correct. The matrix can then be copied to R and submitted to IRT analysis. Doing so will reveal that the agents' behavior is not qualitatively different from a usual human participants' sample in similar analyses.

> Frequency of a fact and extent of agents exposure to said fact, both determine the total exposure of an agent to the fact, which is related to the probability of recalling this fact in a test, according to ACT-R theory.

## Extensions

The same is true for the application of operations. Another variant of the model deals with tasks that require the agent to combine facts retrieved separately. Multifaceted knowledge bases can also be addressed by such a model. Different facets of the knowledge base are not presented to the same degree to the agent. When the agent has to combine retrievals from all segments of the knowledge base, the probability of responding correctly to the overall task is conditional to the exposure to all different segments. 
