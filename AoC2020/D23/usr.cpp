#include <iostream>
#include <vector>
#include <string>
#include <chrono>

struct Node
{
    int val;
    Node* next;
};

void genLinkedList(std::vector<int> &v, Node* head)
{
    Node* temp = head;
    Node* nNode;

    for (int i = 1; i < v.size(); ++i) {
        nNode = (Node*)malloc(sizeof(Node));
        nNode->val = v[i];
        temp->next = nNode;
        temp = nNode;
    }
    nNode->next = head;
}

int getDestination(int i, Node* first, Node* next, const int max, int iter)
{
    if (i == 0) {
        return getDestination(max,first,next,max,iter);
    }
    if (iter == 0) {
        return i;
    }

    if (next->val == i) {
        return getDestination(i-1,first,first,max,3);
    } else {
        return getDestination(i,first,next->next, max, iter-1);
    }
}

void showLL(Node* current) {
    int fstVal = current->val;
    do {
        if (fstVal != current->val)
            std::cout << current->val;
        current = current->next;
    } while (current->val != fstVal);
    std::cout << std::endl;
}

Node* findDestination(Node* head, int val)
{
    Node* current = head;
    while (current->val != val) {
        current = current->next;
    }

    return current;
}

Node* next(Node* a, int times)
{
    for (int i = 0; i < times; ++i) {
        a = a->next;
    }
    return a;
}

void insert(Node* a, Node* b) {
    a->next = b;
}

void calculate(std::vector<int> &v, const int iters, const int star)
{
    Node head = (Node) {.val = v[0],.next = NULL};
    genLinkedList(v,&head);
    Node* current = &head;
    Node* destinationNode;
    int destination;

    std::vector<Node*> pos(v.size()+1);
    pos[0] = NULL;

    do {
        pos[current->val] = current;
        current = current->next;
    } while (current->val != head.val);

    for (int i = 0; i < iters; ++i) {
        destination = getDestination(current->val-1, current->next, current->next, v.size(), 3);
        destinationNode = pos[destination];
        Node* ending = next(current,3);
        Node* nextNode = ending->next;

        insert(ending, destinationNode->next);
        insert(destinationNode, next(current,1));
        insert(current, nextNode);

        current = nextNode;
    }

    current = pos[1];

    if (star == 1) {
        std::cout << "Star1: ";
        showLL(current);
    } else if (star == 2) {
        std::cout << "Star2: ";
        unsigned long fst = (unsigned long)current->next->val;
        unsigned long snd = (unsigned long)current->next->next->val;
        std::cout << fst * snd << std::endl;
    }
}

std::vector<int> parseInput(std::string input)
{
    std::vector<int> v;

    for(char c : input) {
        v.push_back(c - '0');
    }

    return v;
}

void fillVector(std::vector<int> &v)
{
    int lim = 1000000;
    for (int i = 10; i <= lim; ++i) {
        v.push_back(i);
    }
}

int main(int argc, char const *argv[])
{
    std::string input("362981754");
    std::vector<int> v = parseInput(input);
    auto start = std::chrono::high_resolution_clock::now();
    calculate(v, 100, 1);
    auto endfst = std::chrono::high_resolution_clock::now();
    fillVector(v);
    calculate(v, 10000000, 2);
    auto endsnd = std::chrono::high_resolution_clock::now();

    std::chrono::duration<double> elapsedFst = endfst - start;
    std::chrono::duration<double> elapsedSnd = endsnd - endfst;

    std::cout << "Fst took: " << elapsedFst.count() << "; Snd took: " << elapsedSnd.count() << std::endl;
    return 0;
}